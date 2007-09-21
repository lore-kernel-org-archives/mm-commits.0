From: akpm@linux-foundation.org
Subject: + keys-missing-word-in-documentation.patch added to -mm tree
Date: Thu, 20 Sep 2007 23:44:18 -0700
Message-ID: <200709210644.l8L6iI7F023094@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:59885 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750718AbXIUGoe (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 21 Sep 2007 02:44:34 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: alan@lxorguk.ukuu.org.uk, alan@redhat.com, dhowells@redhat.com


The patch titled
     keys: missing word in documentation
has been added to the -mm tree.  Its filename is
     keys-missing-word-in-documentation.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

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

git-libata-all.patch
pata_acpi-rework-the-acpi-drivers-based-upon-experience.patch
libata-correct-handling-of-srst-reset-sequences.patch
libata-add-a-drivers-ide-style-dma-disable.patch
ata-pata_marvell-use-ioread-for-iomap-ped-memory.patch
drivers-ata-pata_ixp4xx_cfc-ioremap-return-code-check.patch
st340823a-hpa-and-libata.patch
libata-fix-hopefully-all-the-remaining-problems-with.patch
introduce-dma_mask_none-as-a-signal-for-unable-to-do.patch
pcmcia-use-dma_mask_none-for-the-default-for-all.patch
serial_txx9-cleanup-includes.patch
serial-keep-the-dtr-setting-for-serial-console.patch
8250_pci-autodetect-mainpine-cards.patch
8250_pci-autodetect-mainpine-cards-fix.patch
wake-up-from-a-serial-port.patch
fix-ide-legacy-mode-resources.patch
fix-ide-legacy-mode-resources-fix.patch
git-scsi-misc.patch
geode-mfgpt-support-for-geode-class-machines.patch
geode-mfgpt-clock-event-device-support.patch
security-convert-lsm-into-a-static-interface-vs-fix-null-pointer-dereference-in-__vm_enough_memory.patch
blackfin-enable-arbitary-speed-serial-setting.patch
mxser-remove-use-of-dead-tty_flipbuf_size-definition.patch
jsm-remove-further-unneeded-crud.patch
ttyh-remove-dead-define.patch
codingstyle-relax-the-80-cole-rule.patch
add-config_vt_unicode.patch
keys-missing-word-in-documentation.patch
sysctl-remove-broken-cdrom-binary-sysctls.patch
mxser-remove-commented-crap.patch
char-cyclades-remove-bottom-half-processing.patch
