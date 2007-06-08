From: akpm@linux-foundation.org
Subject: + libata-correct-abuse-of-language.patch added to -mm tree
Date: Thu, 07 Jun 2007 22:36:27 -0700
Message-ID: <200706080536.l585aR9Y020119@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:50975 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755003AbXFHFhN (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 8 Jun 2007 01:37:13 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: alan@lxorguk.ukuu.org.uk, alan@redhat.com


The patch titled
     libata: correct abuse of language
has been added to the -mm tree.  Its filename is
     libata-correct-abuse-of-language.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: libata: correct abuse of language
From: Alan Cox <alan@lxorguk.ukuu.org.uk>

The controller is not reporting an unlawful type, it is reporting an invalid
type.  Illegal specifically means "prohibited by law"

Signed-off-by: Alan Cox <alan@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/ata/libata-core.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN drivers/ata/libata-core.c~libata-correct-abuse-of-language drivers/ata/libata-core.c
--- a/drivers/ata/libata-core.c~libata-correct-abuse-of-language
+++ a/drivers/ata/libata-core.c
@@ -1697,7 +1697,7 @@ int ata_dev_read_id(struct ata_device *d
 
 	/* sanity check */
 	rc = -EINVAL;
-	reason = "device reports illegal type";
+	reason = "device reports invalid type";
 
 	if (class == ATA_DEV_ATA) {
 		if (!ata_id_is_ata(id) && !ata_id_is_cfa(id))
_

Patches currently in -mm which might be from alan@lxorguk.ukuu.org.uk are

lots-of-architectures-enable-arbitary-speed-tty-support.patch
ia64-arbitary-speed-tty-ioctl-support.patch
git-libata-all.patch
pata-add-the-mcp73-77-support-to-pata-driver.patch
libata-correct-abuse-of-language.patch
libata-core-sff-fix-multiple-assumptions-about-dma.patch
libata-fix-hopefully-all-the-remaining-problems-with.patch
testing-patch-for-ali-pata-fixes-hopefully-for-the-problems-with-atapi-dma.patch
pata_ali-more-work.patch
add-pci_try_set_mwi.patch
git-scsi-misc.patch
add-pci_try_set_mwi-prism54pci.patch
xtensa-enable-arbitary-tty-speed-setting-ioctls.patch
blackfin-enable-arbitary-speed-serial-setting.patch
h8300-enable-arbitary-speed-tty-port-setup.patch
arm26-enable-arbitary-speed-tty-ioctls-and-split.patch
m32r-enable-arbitary-speed-tty-rate-setting.patch
etrax-enable-arbitary-speed-setting-on-tty-ports.patch
v850-enable-arbitary-speed-tty-ioctls.patch
doc-kernel-parameters-use-x86-32-tag-instead-of-ia-32.patch
make-proc-tty-drivers-use-seq_list_xxx-helpers.patch
update-zilog-timeout.patch
edd-switch-to-pci_get-based-api.patch
mpu401-warning-fixes.patch
char-tty_ioctl-use-wait_event_interruptible_timeout.patch
char-tty_ioctl-little-whitespace-cleanup.patch
i2o_cfg_passthru-cleanup.patch
i2o_cfg_passthru-cleanup-fix.patch
wrong-memory-access-in-i2o_block_device_lock.patch
i2o-message-leak-in-i2o_msg_post_wait_mem.patch
i2o-proc-reading-oops.patch
i2o-debug-output-cleanup.patch
coredump-masking-bound-suid_dumpable-sysctl.patch
coredump-masking-reimplementation-of-dumpable-using-two-flags.patch
coredump-masking-reimplementation-of-dumpable-using-two-flags-fix.patch
coredump-masking-add-an-interface-for-core-dump-filter.patch
coredump-masking-elf-enable-core-dump-filtering.patch
coredump-masking-elf-fdpic-remove-an-unused-argument.patch
coredump-masking-elf-fdpic-enable-core-dump-filtering.patch
coredump-masking-documentation-for-proc-pid-coredump_filter.patch
