//go:build windows && !cgo

package main

import (
	"io"
	"time"

	"github.com/Microsoft/go-winio"
)

func dial(path string) (io.ReadWriteCloser, error) {
	// A short per-attempt timeout so the retry loop in startServer controls
	// the overall retry budget precisely, rather than each attempt eating
	// into it unpredictably (DialPipe defaults to 2s per attempt with a nil
	// timeout).
	timeout := 500 * time.Millisecond
	return winio.DialPipe(path, &timeout)
}
