From: akpm@linux-foundation.org
Subject: - keys-missing-word-in-documentation.patch removed from -mm tree
Date: Tue, 16 Oct 2007 15:24:49 -0700
Message-ID: <200710162224.l9GMOn1e020891@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:38958 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S934239AbXJPWZE (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 16 Oct 2007 18:25:04 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: alan@lxorguk.ukuu.org.uk, alan@redhat.com, dhowells@redhat.com, mm-commits@vger.kernel.org


The patch titled
     keys: missing word in documentation
has been removed from the -mm tree.  Its filename was
     keys-missing-word-in-documentation.patch

This patch was dropped because it was folded into keys-make-request_key-and-co-fundamentally-asynchronous.patch

------------------------------------------------------
Subject: keys: missing word in documentation
From: Alan Cox <alan@lxorguk.ukuu.org.uk>

Signed-off-by: Alan Cox <alan@redhat.com>
Cc: David Howells <dhowells@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/keys.txt |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN Documentation/keys.txt~keys-missing-word-in-documentation Documentation/keys.txt
--- a/Documentation/keys.txt~keys-missing-word-in-documentation
+++ a/Documentation/keys.txt
@@ -4,7 +4,7 @@
 
 This service allows cryptographic keys, authentication tokens, cross-domain
 user mappings, and similar to be cached in the kernel for the use of
-filesystems other kernel services.
+filesystems and other kernel services.
 
 Keyrings are permitted; these are a special type of key that can hold links to
 other keys. Processes each have three standard keyring subscriptions that a
_

Patches currently in -mm which might be from alan@lxorguk.ukuu.org.uk are

origin.patch
mxser-remove-use-of-dead-tty_flipbuf_size-definition.patch
jsm-remove-further-unneeded-crud.patch
ttyh-remove-dead-define.patch
codingstyle-relax-the-80-cole-rule.patch
add-config_vt_unicode.patch
keys-make-request_key-and-co-fundamentally-asynchronous.patch
keys-missing-word-in-documentation.patch
ide-cd-is-unmaintained.patch
tty-expose-new-methods-needed-for-drivers-to-get-termios.patch
tty-expose-new-methods-needed-for-drivers-to-get-termios-fix.patch
fs-correct-sus-compliance-for-open-of-large-file-without.patch
sysctl-remove-broken-cdrom-binary-sysctls.patch
mxser-remove-commented-crap.patch
char-cyclades-remove-bottom-half-processing.patch
usb_serial-stop-passing-null-to-functions-that-expect-data.patch
ark3116-update-termios-handling.patch
usb-serial-kill-another-case-we-pass-null-and-shouldnt.patch
ch341-fix-termios-handling.patch
digi_acceleport-fix-termios-and-also-readability-a-bit.patch
empeg-clean-up-and-handle-speeds.patch
ir_usb-termios-handling.patch
keyspan-termios-tidy.patch
kobil_sct-termios-encoding-fixups.patch
option-termios-handling.patch
sierra-termios.patch
usb-serial-handle-null-termios-methods-as-no-hardware-changing-support.patch
whiteheat-clean-up-cant-happen-checks-and-encode-baud.patch
cp2101-convert-to-new-termios.patch
ftd_sio-clean-ups-and-updates-for-new-termios-work.patch
ftd_sio-clean-ups-and-updates-for-new-termios-work-checkpatch-fixes.patch
io_edgeport-cleanups-and-tty-speed-reporting.patch
tty-kill-tty_flipbuf_size.patch
