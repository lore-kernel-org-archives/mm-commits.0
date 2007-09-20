From: akpm@linux-foundation.org
Subject: + sound-hda-fix-help-text.patch added to -mm tree
Date: Thu, 20 Sep 2007 16:24:28 -0700
Message-ID: <200709202324.l8KNOSXg008011@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:35669 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751275AbXITXZO (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 20 Sep 2007 19:25:14 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: randy.dunlap@oracle.com, perex@suse.cz, tiwai@suse.de


The patch titled
     sound/hda: fix help text
has been added to the -mm tree.  Its filename is
     sound-hda-fix-help-text.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: sound/hda: fix help text
From: Randy Dunlap <randy.dunlap@oracle.com>

Fix hda help text typo.

Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
Cc: Jaroslav Kysela <perex@suse.cz>
Cc: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 sound/pci/Kconfig |    2 +-
 1 files changed, 1 insertion(+), 1 deletion(-)

diff -puN sound/pci/Kconfig~sound-hda-fix-help-text sound/pci/Kconfig
--- a/sound/pci/Kconfig~sound-hda-fix-help-text
+++ a/sound/pci/Kconfig
@@ -506,7 +506,7 @@ config SND_HDA_HWDEP
 	select SND_HWDEP
 	help
 	  Say Y here to build a hwdep interface for HD-audio driver.
-	  This interface can be used for out-of-bound communication
+	  This interface can be used for out-of-band communication
 	  with codecs for debugging purposes.
 
 config SND_HDA_CODEC_REALTEK
_

Patches currently in -mm which might be from randy.dunlap@oracle.com are

git-acpi.patch
fix-auditscc-kernel-doc.patch
git-kbuild.patch
menuconfig-distinguish-between-selected-by-another-options-and-comments.patch
git-mtd.patch
git-net.patch
git-nfsd.patch
git-unionfs.patch
git-watchdog.patch
git-ipwireless_cs.patch
security-convert-lsm-into-a-static-interface-fix-2-fix.patch
docs-ramdisk-initrd-initramfs-corrections.patch
send-quota-messages-via-netlink-fix.patch
send-quota-messages-via-netlink-fix-fix.patch
maintainers-linux-omap-list-is-subscribers-only.patch
make-the-pr_-family-of-macros-in-kernelh-complete.patch
doc-about-email-clients-for-linux-patches.patch
kernel-doc-fix-doc-blocks-and-html.patch
express-relocatability-of-kernel-on-x86_64-in.patch
profile-likely-unlikely-macros.patch
sound-hda-fix-help-text.patch
kgdb-fix-help-text.patch
