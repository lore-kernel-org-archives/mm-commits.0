From: akpm@osdl.org
Subject: - log2-implement-a-general-integer-log2-facility-in-the-kernel-vs-git-cryptodev.patch removed from -mm tree
Date: Fri, 08 Dec 2006 00:50:45 -0800
Message-ID: <200612080850.kB88okIv013933@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.25]:37216 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1425204AbWLHIva (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Fri, 8 Dec 2006 03:51:30 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@osdl.org, dhowells@redhat.com, herbert@gondor.apana.org.au, mm-commits@vger.kernel.org


The patch titled
     log2-implement-a-general-integer-log2-facility-in-the-kernel vs git-cryptodev.txt
has been removed from the -mm tree.  Its filename was
     log2-implement-a-general-integer-log2-facility-in-the-kernel-vs-git-cryptodev.patch

This patch was dropped because it was folded into log2-implement-a-general-integer-log2-facility-in-the-kernel.patch

------------------------------------------------------
Subject: log2-implement-a-general-integer-log2-facility-in-the-kernel vs git-cryptodev.txt
From: Andrew Morton <akpm@osdl.org>

David taketh away, Herbert useth.

Cc: Herbert Xu <herbert@gondor.apana.org.au>
Cc: David Howells <dhowells@redhat.com>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 drivers/md/dm-crypt.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN drivers/md/dm-crypt.c~log2-implement-a-general-integer-log2-facility-in-the-kernel-vs-git-cryptodev drivers/md/dm-crypt.c
--- a/drivers/md/dm-crypt.c~log2-implement-a-general-integer-log2-facility-in-the-kernel-vs-git-cryptodev
+++ a/drivers/md/dm-crypt.c
@@ -217,7 +217,7 @@ static int crypt_iv_benbi_ctr(struct cry
 			      const char *opts)
 {
 	unsigned int bs = crypto_blkcipher_blocksize(cc->tfm);
-	int log = long_log2(bs);
+	int log = ilog2(bs);
 
 	/* we need to calculate how far we must shift the sector count
 	 * to get the cipher block count, we use this shift in _gen */
_

Patches currently in -mm which might be from akpm@osdl.org are

origin.patch
node-aware-skb-allocation-fix-for-device-tree-changes.patch
tty-signal-tty-locking.patch
pktcdvd-bio-write-congestion-using-blk_congestion_wait.patch
fsstack-introduce-fsstack_copy_attrinode_.patch
log2-implement-a-general-integer-log2-facility-in-the-kernel.patch
log2-implement-a-general-integer-log2-facility-in-the-kernel-vs-git-cryptodev.patch
log2-implement-a-general-integer-log2-facility-in-the-kernel-ppc-fix.patch
add-process_session-helper-routine-deprecate-old-field-tidy.patch
add-process_session-helper-routine-deprecate-old-field-fix-warnings.patch
add-process_session-helper-routine-deprecate-old-field-fix-warnings-2.patch
mxser-session-warning-fix.patch
mxser-workqueue-fixes.patch
tty-switch-to-ktermios-and-new-framework-warning-fix.patch
tty-switch-to-ktermios-and-new-framework-irda-fix.patch
tty-switch-to-ktermios-bluetooth-fix.patch
tty_ioctl-use-termios-for-the-old-structure-and-termios2-fix.patch
drivers-isdn-handcrafted-min-max-macro-removal-fix.patch
fault-injection-capabilities-infrastructure-tidy.patch
fault-injection-capabilities-infrastructure-tweaks.patch
fault-injection-Kconfig-cleanup.patch
fault-injection-stacktrace-filtering-kconfig-fix.patch
sysctl-fix-sys_sysctl-interface-of-ipc-sysctls-fix-3.patch
video-get-the-default-mode-from-the-right-database.patch
various-fbdev-files-mark-structs-fix.patch
backlight-lcd-remove-dependenct-from-the-framebuffer-layer-tidy.patch
gxfb-fixups-for-the-amd-geode-gx-tidy.patch
gxfb-support-flat-panel-timings-tidy.patch
gxfb-support-command-line-options-tidy.patch

