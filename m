From: akpm@linux-foundation.org
Subject: - add-pci_try_set_mwi-prism54pci.patch removed from -mm tree
Date: Wed, 09 May 2007 15:25:08 -0700
Message-ID: <200705092225.l49MP8U6004212@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([65.172.181.25]:39371 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758417AbXEIWZl (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 9 May 2007 18:25:41 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: randy.dunlap@oracle.com, alan@lxorguk.ukuu.org.uk, greg@kroah.com, mm-commits@vger.kernel.org


The patch titled
     add pci_try_set_mwi
has been removed from the -mm tree.  Its filename was
     add-pci_try_set_mwi-prism54pci.patch

This patch was dropped because I'm cleaning old stuff out of my patches directory

------------------------------------------------------
Subject: add pci_try_set_mwi

diff -puN drivers/net/wireless/mac80211/p54/prism54pci.c~add-pci_try_set_mwi drivers/net/wireless/mac80211/p54/prism54pci.c
--- a/drivers/net/wireless/mac80211/p54/prism54pci.c~add-pci_try_set_mwi
+++ a/drivers/net/wireless/mac80211/p54/prism54pci.c
@@ -539,7 +539,7 @@ static int __devinit p54p_probe(struct p
 	}
 
 	pci_set_master(pdev);
-	pci_set_mwi(pdev);
+	pci_try_set_mwi(pdev);
 
 	pci_write_config_byte(pdev, 0x40, 0);
 	pci_write_config_byte(pdev, 0x41, 0);


Patches currently in -mm which might be from randy.dunlap@oracle.com are

origin.patch
ocfs2-kobject-kset-foobar.patch
git-acpi.patch
git-ieee1394.patch
romfs-printk-format-warnings.patch
add-pci_try_set_mwi.patch
git-unionfs.patch
git-ipwireless_cs.patch
mm-merge-populate-and-nopage-into-fault-fixes-nonlinear-doc-fix.patch
doc-kernel-parameters-use-x86-32-tag-instead-of-ia-32.patch
lib-hexdump.patch
profile-likely-unlikely-macros.patch
