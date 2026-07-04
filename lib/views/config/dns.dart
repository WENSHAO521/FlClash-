import 'package:fl_clash/common/common.dart';
import 'package:fl_clash/enum/enum.dart';
import 'package:fl_clash/models/models.dart';
import 'package:fl_clash/providers/config.dart';
import 'package:fl_clash/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

enum DnsPreset {
  globalPrivacy,
  chinaCompatibility,
  custom,
}

const _privacyFallbackFilter = FallbackFilter();

const _globalPrivacyDns = Dns(
  listen: '127.0.0.1:1053',
  preferH3: false,
  respectRules: true,
  defaultNameserver: ['1.1.1.1', '9.9.9.9'],
  nameserver: [
    'https://cloudflare-dns.com/dns-query',
    'https://dns.quad9.net/dns-query',
  ],
  fallback: ['https://dns.google/dns-query'],
  proxyServerNameserver: [
    'https://cloudflare-dns.com/dns-query',
    'https://dns.quad9.net/dns-query',
  ],
  nameserverPolicy: {},
  fallbackFilter: _privacyFallbackFilter,
);

const _chinaCompatibilityDns = Dns(
  listen: '127.0.0.1:1053',
  preferH3: false,
  respectRules: true,
  defaultNameserver: ['223.5.5.5', '119.29.29.29'],
  nameserver: [
    'https://dns.alidns.com/dns-query',
    'https://doh.pub/dns-query',
  ],
  fallback: [
    'https://cloudflare-dns.com/dns-query',
    'https://dns.quad9.net/dns-query',
  ],
  proxyServerNameserver: [
    'https://dns.alidns.com/dns-query',
    'https://doh.pub/dns-query',
  ],
  nameserverPolicy: {},
  fallbackFilter: _privacyFallbackFilter,
);

DnsPreset _resolveDnsPreset(Dns dns) {
  if (dns == _globalPrivacyDns) {
    return DnsPreset.globalPrivacy;
  }
  if (dns == _chinaCompatibilityDns) {
    return DnsPreset.chinaCompatibility;
  }
  return DnsPreset.custom;
}

Dns _dnsForPreset(DnsPreset preset) {
  return switch (preset) {
    DnsPreset.globalPrivacy => _globalPrivacyDns,
    DnsPreset.chinaCompatibility => _chinaCompatibilityDns,
    DnsPreset.custom => _globalPrivacyDns,
  };
}

String _dnsPresetLabel(DnsPreset preset) {
  final appLocalizations = currentAppLocalizations;
  return switch (preset) {
    DnsPreset.globalPrivacy => appLocalizations.dnsPresetGlobalPrivacy,
    DnsPreset.chinaCompatibility =>
      appLocalizations.dnsPresetChinaCompatibility,
    DnsPreset.custom => appLocalizations.dnsPresetCustom,
  };
}

String _dnsPresetDescription(DnsPreset preset) {
  final appLocalizations = currentAppLocalizations;
  return switch (preset) {
    DnsPreset.globalPrivacy => appLocalizations.dnsPresetGlobalPrivacyDesc,
    DnsPreset.chinaCompatibility =>
      appLocalizations.dnsPresetChinaCompatibilityDesc,
    DnsPreset.custom => appLocalizations.dnsPresetCustom,
  };
}

class OverrideItem extends ConsumerWidget {
  const OverrideItem({super.key});

  @override
  Widget build(BuildContext context, ref) {
    final appLocalizations = context.appLocalizations;
    final override = ref.watch(overrideDnsProvider);
    return ListItem.switchItem(
      title: Text(appLocalizations.overrideDns),
      subtitle: Text(appLocalizations.overrideDnsDesc),
      delegate: SwitchDelegate(
        value: override,
        onChanged: (bool value) async {
          ref.read(overrideDnsProvider.notifier).value = value;
        },
      ),
    );
  }
}

class DnsPresetItem extends ConsumerWidget {
  const DnsPresetItem({super.key});

  @override
  Widget build(BuildContext context, ref) {
    final appLocalizations = context.appLocalizations;
    final dns = ref.watch(patchClashConfigProvider.select((state) => state.dns));
    final preset = _resolveDnsPreset(dns);
    return ListItem<DnsPreset>.options(
      leading: const Icon(Icons.dns_outlined),
      title: Text(appLocalizations.dnsPreset),
      subtitle: Text(_dnsPresetDescription(preset)),
      delegate: OptionsDelegate(
        title: appLocalizations.dnsPreset,
        options: DnsPreset.values,
        onChanged: (value) {
          if (value == null || value == DnsPreset.custom) {
            return;
          }
          ref.read(overrideDnsProvider.notifier).value = true;
          ref
              .read(networkSettingProvider.notifier)
              .update((state) => state.copyWith(appendSystemDns: false));
          ref
              .read(patchClashConfigProvider.notifier)
              .update((state) => state.copyWith(dns: _dnsForPreset(value)));
        },
        textBuilder: _dnsPresetLabel,
        value: preset,
      ),
    );
  }
}

class StatusItem extends ConsumerWidget {
  const StatusItem({super.key});

  @override
  Widget build(BuildContext context, ref) {
    final appLocalizations = context.appLocalizations;
    final enable = ref.watch(
      patchClashConfigProvider.select((state) => state.dns.enable),
    );
    return ListItem.switchItem(
      title: Text(appLocalizations.status),
      subtitle: Text(appLocalizations.statusDesc),
      delegate: SwitchDelegate(
        value: enable,
        onChanged: (bool value) async {
          ref
              .read(patchClashConfigProvider.notifier)
              .update((state) => state.copyWith.dns(enable: value));
        },
      ),
    );
  }
}

class ListenItem extends ConsumerWidget {
  const ListenItem({super.key});

  @override
  Widget build(BuildContext context, ref) {
    final appLocalizations = context.appLocalizations;
    final listen = ref.watch(
      patchClashConfigProvider.select((state) => state.dns.listen),
    );
    return ListItem.input(
      title: Text(appLocalizations.listen),
      subtitle: Text(listen),
      delegate: InputDelegate(
        title: appLocalizations.listen,
        value: listen,
        validator: (value) {
          if (value == null || value.isEmpty) {
            return appLocalizations.emptyTip(appLocalizations.listen);
          }
          return null;
        },
        onChanged: (String? value) {
          if (value == null) {
            return;
          }
          ref
              .read(patchClashConfigProvider.notifier)
              .update((state) => state.copyWith.dns(listen: value));
        },
      ),
    );
  }
}

class PreferH3Item extends ConsumerWidget {
  const PreferH3Item({super.key});

  @override
  Widget build(BuildContext context, ref) {
    final appLocalizations = context.appLocalizations;
    final preferH3 = ref.watch(
      patchClashConfigProvider.select((state) => state.dns.preferH3),
    );
    return ListItem.switchItem(
      title: const Text('PreferH3'),
      subtitle: Text(appLocalizations.preferH3Desc),
      delegate: SwitchDelegate(
        value: preferH3,
        onChanged: (bool value) async {
          ref
              .read(patchClashConfigProvider.notifier)
              .update((state) => state.copyWith.dns(preferH3: value));
        },
      ),
    );
  }
}

class IPv6Item extends ConsumerWidget {
  const IPv6Item({super.key});

  @override
  Widget build(BuildContext context, ref) {
    final ipv6 = ref.watch(
      patchClashConfigProvider.select((state) => state.dns.ipv6),
    );
    return ListItem.switchItem(
      title: const Text('IPv6'),
      delegate: SwitchDelegate(
        value: ipv6,
        onChanged: (bool value) async {
          ref
              .read(patchClashConfigProvider.notifier)
              .update((state) => state.copyWith.dns(ipv6: value));
        },
      ),
    );
  }
}

class RespectRulesItem extends ConsumerWidget {
  const RespectRulesItem({super.key});

  @override
  Widget build(BuildContext context, ref) {
    final appLocalizations = context.appLocalizations;
    final respectRules = ref.watch(
      patchClashConfigProvider.select((state) => state.dns.respectRules),
    );
    return ListItem.switchItem(
      title: Text(appLocalizations.respectRules),
      subtitle: Text(appLocalizations.respectRulesDesc),
      delegate: SwitchDelegate(
        value: respectRules,
        onChanged: (bool value) async {
          ref
              .read(patchClashConfigProvider.notifier)
              .update((state) => state.copyWith.dns(respectRules: value));
        },
      ),
    );
  }
}

class DnsModeItem extends ConsumerWidget {
  const DnsModeItem({super.key});

  @override
  Widget build(BuildContext context, ref) {
    final appLocalizations = context.appLocalizations;
    final enhancedMode = ref.watch(
      patchClashConfigProvider.select((state) => state.dns.enhancedMode),
    );
    return ListItem<DnsMode>.options(
      title: Text(appLocalizations.dnsMode),
      subtitle: Text(enhancedMode.name),
      delegate: OptionsDelegate(
        title: appLocalizations.dnsMode,
        options: DnsMode.values,
        onChanged: (value) {
          if (value == null) {
            return;
          }
          ref
              .read(patchClashConfigProvider.notifier)
              .update((state) => state.copyWith.dns(enhancedMode: value));
        },
        textBuilder: (dnsMode) => dnsMode.name,
        value: enhancedMode,
      ),
    );
  }
}

class FakeIpRangeItem extends ConsumerWidget {
  const FakeIpRangeItem({super.key});

  @override
  Widget build(BuildContext context, ref) {
    final appLocalizations = context.appLocalizations;
    final fakeIpRange = ref.watch(
      patchClashConfigProvider.select((state) => state.dns.fakeIpRange),
    );
    return ListItem.input(
      title: Text(appLocalizations.fakeipRange),
      subtitle: Text(fakeIpRange),
      delegate: InputDelegate(
        title: appLocalizations.fakeipRange,
        value: fakeIpRange,
        validator: (value) {
          if (value == null || value.isEmpty) {
            return appLocalizations.emptyTip(appLocalizations.fakeipRange);
          }
          return null;
        },
        onChanged: (String? value) {
          if (value == null) {
            return;
          }
          ref
              .read(patchClashConfigProvider.notifier)
              .update((state) => state.copyWith.dns(fakeIpRange: value));
        },
      ),
    );
  }
}

class FakeIpFilterItem extends ConsumerWidget {
  const FakeIpFilterItem({super.key});

  @override
  Widget build(BuildContext context, ref) {
    final appLocalizations = context.appLocalizations;
    final fakeIpFilter = ref.watch(
      patchClashConfigProvider.select((state) => state.dns.fakeIpFilter),
    );
    return ListItem.open(
      title: Text(appLocalizations.fakeipFilter),
      delegate: OpenDelegate(
        blur: false,
        widget: ListInputPage(
          title: appLocalizations.fakeipFilter,
          items: fakeIpFilter,
          titleBuilder: (item) => Text(item),
        ),
        onChanged: (items) {
          ref
              .read(patchClashConfigProvider.notifier)
              .update(
                (state) => state.copyWith.dns(fakeIpFilter: List.from(items)),
              );
        },
      ),
    );
  }
}

class DefaultNameserverItem extends ConsumerWidget {
  const DefaultNameserverItem({super.key});

  @override
  Widget build(BuildContext context, ref) {
    final appLocalizations = context.appLocalizations;
    final defaultNameserver = ref.watch(
      patchClashConfigProvider.select((state) => state.dns.defaultNameserver),
    );
    return ListItem.open(
      title: Text(appLocalizations.defaultNameserver),
      subtitle: Text(appLocalizations.defaultNameserverDesc),
      delegate: OpenDelegate(
        blur: false,
        widget: ListInputPage(
          title: appLocalizations.defaultNameserver,
          items: defaultNameserver,
          titleBuilder: (item) => Text(item),
        ),
        onChanged: (items) {
          ref
              .read(patchClashConfigProvider.notifier)
              .update(
                (state) =>
                    state.copyWith.dns(defaultNameserver: List.from(items)),
              );
        },
      ),
    );
  }
}

class NameserverItem extends ConsumerWidget {
  const NameserverItem({super.key});

  @override
  Widget build(BuildContext context, ref) {
    final appLocalizations = context.appLocalizations;
    final nameserver = ref.watch(
      patchClashConfigProvider.select((state) => state.dns.nameserver),
    );
    return ListItem.open(
      title: Text(appLocalizations.nameserver),
      subtitle: Text(appLocalizations.nameserverDesc),
      delegate: OpenDelegate(
        blur: false,
        widget: ListInputPage(
          title: appLocalizations.nameserver,
          items: nameserver,
          titleBuilder: (item) => Text(item),
        ),
        onChanged: (items) {
          ref
              .read(patchClashConfigProvider.notifier)
              .update(
                (state) => state.copyWith.dns(nameserver: List.from(items)),
              );
        },
      ),
    );
  }
}

class UseHostsItem extends ConsumerWidget {
  const UseHostsItem({super.key});

  @override
  Widget build(BuildContext context, ref) {
    final appLocalizations = context.appLocalizations;
    final useHosts = ref.watch(
      patchClashConfigProvider.select((state) => state.dns.useHosts),
    );
    return ListItem.switchItem(
      title: Text(appLocalizations.useHosts),
      delegate: SwitchDelegate(
        value: useHosts,
        onChanged: (bool value) async {
          ref
              .read(patchClashConfigProvider.notifier)
              .update((state) => state.copyWith.dns(useHosts: value));
        },
      ),
    );
  }
}

class UseSystemHostsItem extends ConsumerWidget {
  const UseSystemHostsItem({super.key});

  @override
  Widget build(BuildContext context, ref) {
    final appLocalizations = context.appLocalizations;
    final useSystemHosts = ref.watch(
      patchClashConfigProvider.select((state) => state.dns.useSystemHosts),
    );
    return ListItem.switchItem(
      title: Text(appLocalizations.useSystemHosts),
      delegate: SwitchDelegate(
        value: useSystemHosts,
        onChanged: (bool value) async {
          ref
              .read(patchClashConfigProvider.notifier)
              .update((state) => state.copyWith.dns(useSystemHosts: value));
        },
      ),
    );
  }
}

class NameserverPolicyItem extends ConsumerWidget {
  const NameserverPolicyItem({super.key});

  @override
  Widget build(BuildContext context, ref) {
    final appLocalizations = context.appLocalizations;
    final nameserverPolicy = ref.watch(
      patchClashConfigProvider.select((state) => state.dns.nameserverPolicy),
    );
    return ListItem.open(
      title: Text(appLocalizations.nameserverPolicy),
      subtitle: Text(appLocalizations.nameserverPolicyDesc),
      delegate: OpenDelegate(
        blur: false,
        widget: MapInputPage(
          title: appLocalizations.nameserverPolicy,
          map: nameserverPolicy,
          titleBuilder: (item) => Text(item.key),
          subtitleBuilder: (item) => Text(item.value),
        ),
        onChanged: (value) {
          ref
              .read(patchClashConfigProvider.notifier)
              .update((state) => state.copyWith.dns(nameserverPolicy: value));
        },
      ),
    );
  }
}

class ProxyServerNameserverItem extends ConsumerWidget {
  const ProxyServerNameserverItem({super.key});

  @override
  Widget build(BuildContext context, ref) {
    final appLocalizations = context.appLocalizations;
    final proxyServerNameserver = ref.watch(
      patchClashConfigProvider.select(
        (state) => state.dns.proxyServerNameserver,
      ),
    );
    return ListItem.open(
      title: Text(appLocalizations.proxyNameserver),
      subtitle: Text(appLocalizations.proxyNameserverDesc),
      delegate: OpenDelegate(
        blur: false,
        widget: ListInputPage(
          title: appLocalizations.proxyNameserver,
          items: proxyServerNameserver,
          titleBuilder: (item) => Text(item),
        ),
        onChanged: (items) {
          ref
              .read(patchClashConfigProvider.notifier)
              .update(
                (state) =>
                    state.copyWith.dns(proxyServerNameserver: List.from(items)),
              );
        },
      ),
    );
  }
}

class FallbackItem extends ConsumerWidget {
  const FallbackItem({super.key});

  @override
  Widget build(BuildContext context, ref) {
    final appLocalizations = context.appLocalizations;
    final fallback = ref.watch(
      patchClashConfigProvider.select((state) => state.dns.fallback),
    );
    return ListItem.open(
      title: Text(appLocalizations.fallback),
      subtitle: Text(appLocalizations.fallbackDesc),
      delegate: OpenDelegate(
        blur: false,
        widget: ListInputPage(
          title: appLocalizations.fallback,
          items: fallback,
          titleBuilder: (item) => Text(item),
        ),
        onChanged: (items) {
          ref
              .read(patchClashConfigProvider.notifier)
              .update(
                (state) => state.copyWith.dns(fallback: List.from(items)),
              );
        },
      ),
    );
  }
}

class GeoipItem extends ConsumerWidget {
  const GeoipItem({super.key});

  @override
  Widget build(BuildContext context, ref) {
    final geoip = ref.watch(
      patchClashConfigProvider.select(
        (state) => state.dns.fallbackFilter.geoip,
      ),
    );
    return ListItem.switchItem(
      title: const Text('Geoip'),
      delegate: SwitchDelegate(
        value: geoip,
        onChanged: (bool value) async {
          ref
              .read(patchClashConfigProvider.notifier)
              .update(
                (state) => state.copyWith.dns.fallbackFilter(geoip: value),
              );
        },
      ),
    );
  }
}

class GeoipCodeItem extends ConsumerWidget {
  const GeoipCodeItem({super.key});

  @override
  Widget build(BuildContext context, ref) {
    final appLocalizations = context.appLocalizations;
    final geoipCode = ref.watch(
      patchClashConfigProvider.select(
        (state) => state.dns.fallbackFilter.geoipCode,
      ),
    );
    return ListItem.input(
      title: Text(appLocalizations.geoipCode),
      subtitle: Text(geoipCode),
      delegate: InputDelegate(
        title: appLocalizations.geoipCode,
        value: geoipCode,
        validator: (value) {
          if (value == null || value.isEmpty) {
            return appLocalizations.emptyTip(appLocalizations.geoipCode);
          }
          return null;
        },
        onChanged: (String? value) {
          if (value == null) {
            return;
          }
          ref
              .read(patchClashConfigProvider.notifier)
              .update(
                (state) => state.copyWith.dns.fallbackFilter(geoipCode: value),
              );
        },
      ),
    );
  }
}

class GeositeItem extends ConsumerWidget {
  const GeositeItem({super.key});

  @override
  Widget build(BuildContext context, ref) {
    final geosite = ref.watch(
      patchClashConfigProvider.select(
        (state) => state.dns.fallbackFilter.geosite,
      ),
    );
    return ListItem.open(
      title: const Text('Geosite'),
      delegate: OpenDelegate(
        blur: false,
        widget: ListInputPage(
          title: 'Geosite',
          items: geosite,
          titleBuilder: (item) => Text(item),
        ),
        onChanged: (items) {
          ref
              .read(patchClashConfigProvider.notifier)
              .update(
                (state) => state.copyWith.dns.fallbackFilter(
                  geosite: List.from(items),
                ),
              );
        },
      ),
    );
  }
}

class IpcidrItem extends ConsumerWidget {
  const IpcidrItem({super.key});

  @override
  Widget build(BuildContext context, ref) {
    final appLocalizations = context.appLocalizations;
    final ipcidr = ref.watch(
      patchClashConfigProvider.select(
        (state) => state.dns.fallbackFilter.ipcidr,
      ),
    );
    return ListItem.open(
      title: Text(appLocalizations.ipcidr),
      delegate: OpenDelegate(
        blur: false,
        widget: ListInputPage(
          title: appLocalizations.ipcidr,
          items: ipcidr,
          titleBuilder: (item) => Text(item),
        ),
        onChanged: (items) {
          ref
              .read(patchClashConfigProvider.notifier)
              .update(
                (state) =>
                    state.copyWith.dns.fallbackFilter(ipcidr: List.from(items)),
              );
        },
      ),
    );
  }
}

class DomainItem extends ConsumerWidget {
  const DomainItem({super.key});

  @override
  Widget build(BuildContext context, ref) {
    final appLocalizations = context.appLocalizations;
    final domain = ref.watch(
      patchClashConfigProvider.select(
        (state) => state.dns.fallbackFilter.domain,
      ),
    );
    return ListItem.open(
      title: Text(appLocalizations.domain),
      delegate: OpenDelegate(
        blur: false,
        widget: ListInputPage(
          title: appLocalizations.domain,
          items: domain,
          titleBuilder: (item) => Text(item),
        ),
        onChanged: (items) {
          ref
              .read(patchClashConfigProvider.notifier)
              .update(
                (state) =>
                    state.copyWith.dns.fallbackFilter(domain: List.from(items)),
              );
        },
      ),
    );
  }
}

class DnsOptions extends StatelessWidget {
  const DnsOptions({super.key});

  @override
  Widget build(BuildContext context) {
    final appLocalizations = context.appLocalizations;
    return Column(
      children: generateSection(
        title: appLocalizations.options,
        items: [
          const StatusItem(),
          const ListenItem(),
          const UseHostsItem(),
          const UseSystemHostsItem(),
          const IPv6Item(),
          const RespectRulesItem(),
          const PreferH3Item(),
          const DnsModeItem(),
          const FakeIpRangeItem(),
          const FakeIpFilterItem(),
          const DefaultNameserverItem(),
          const NameserverPolicyItem(),
          const NameserverItem(),
          const FallbackItem(),
          const ProxyServerNameserverItem(),
        ],
      ),
    );
  }
}

class FallbackFilterOptions extends StatelessWidget {
  const FallbackFilterOptions({super.key});

  @override
  Widget build(BuildContext context) {
    final appLocalizations = context.appLocalizations;
    return Column(
      children: generateSection(
        title: appLocalizations.fallbackFilter,
        items: [
          const GeoipItem(),
          const GeoipCodeItem(),
          const GeositeItem(),
          const IpcidrItem(),
          const DomainItem(),
        ],
      ),
    );
  }
}

const dnsItems = <Widget>[
  OverrideItem(),
  DnsPresetItem(),
  DnsOptions(),
  FallbackFilterOptions(),
];

class DnsListView extends ConsumerWidget {
  const DnsListView({super.key});

  @override
  Widget build(BuildContext context, ref) {
    return generateListView(dnsItems);
  }
}
