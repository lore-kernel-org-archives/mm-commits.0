From: akpm@linux-foundation.org
Subject: + mn10300-fix-typo-in-arch-mn10300-unit-asb2305-pcic.patch added to -mm tree
Date: Thu, 19 Feb 2009 12:21:05 -0800
Message-ID: <200902192021.n1JKL5RB020449@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:48479 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753370AbZBSUVx (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 19 Feb 2009 15:21:53 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: yjwei@cn.fujitsu.com, dhowells@redhat.com


The patch titled
     mn10300: fix typo && -> || in arch/mn10300/unit-asb2305/pci.c
has been added to the -mm tree.  Its filename is
     mn10300-fix-typo-in-arch-mn10300-unit-asb2305-pcic.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://userweb.kernel.org/~akpm/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: mn10300: fix typo && -> || in arch/mn10300/unit-asb2305/pci.c
From: Wei Yongjun <yjwei@cn.fujitsu.com>

Fix the typo && -> ||.

Signed-off-by: Wei Yongjun <yjwei@cn.fujitsu.com>
Signed-off-by: David Howells <dhowells@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/mn10300/unit-asb2305/pci.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN arch/mn10300/unit-asb2305/pci.c~mn10300-fix-typo-in-arch-mn10300-unit-asb2305-pcic arch/mn10300/unit-asb2305/pci.c
--- a/arch/mn10300/unit-asb2305/pci.c~mn10300-fix-typo-in-arch-mn10300-unit-asb2305-pcic
+++ a/arch/mn10300/unit-asb2305/pci.c
@@ -173,7 +173,7 @@ static int pci_ampci_write_config_byte(s
 		BRIDGEREGB(where) = value;
 	} else {
 		if (bus->number == 0 &&
-		    (devfn == PCI_DEVFN(2, 0) && devfn == PCI_DEVFN(3, 0))
+		    (devfn == PCI_DEVFN(2, 0) || devfn == PCI_DEVFN(3, 0))
 		    )
 			__pcidebug("<= %02x", bus, devfn, where, value);
 		CONFIG_ADDRESS = CONFIG_CMD(bus, devfn, where);
_

Patches currently in -mm which might be from yjwei@cn.fujitsu.com are

origin.patch
mn10300-fix-typo-in-arch-mn10300-unit-asb2305-pcic.patch
linux-next.patch
fs-jffs2-mallocc-kmem_cache_alloc-memset-kmem_cache_zalloc.patch
ext4-use-unsigned-instead-of-int-for-type-of-blocksize-in-fs-ext4-nameic.patch
scsi-used-kmem_cache_zalloc-instead-of-kmem_cache_alloc-memset.patch
ext3-use-unsigned-instead-of-int-for-type-of-blocksize-in-fs-ext3-nameic.patch
ext3-use-unsigned-instead-of-int-for-type-of-blocksize-in-fs-ext3-nameic-fix.patch
ext3-use-unsigned-instead-of-int-for-type-of-blocksize-in-fs-ext3-nameic-fix-checkpatch-fixes.patch

