From: akpm@linux-foundation.org
Subject: + ncpfs-update-diagnostic-strings-to-match-routine-names.patch added to -mm tree
Date: Mon, 26 Nov 2007 15:34:16 -0800
Message-ID: <200711262334.lAQNYGei028880@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:58545 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754163AbXKZXeZ (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 26 Nov 2007 18:34:25 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: rpjday@crashcourse.ca, VANDROVE@vc.cvut.cz


The patch titled
     NCPFS: update diagnostic strings to match routine names.
has been added to the -mm tree.  Its filename is
     ncpfs-update-diagnostic-strings-to-match-routine-names.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: NCPFS: update diagnostic strings to match routine names.
From: "Robert P. J. Day" <rpjday@crashcourse.ca>

Signed-off-by: Robert P. J. Day <rpjday@crashcourse.ca>
Cc: Petr Vandrovec <VANDROVE@vc.cvut.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/ncpfs/inode.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff -puN fs/ncpfs/inode.c~ncpfs-update-diagnostic-strings-to-match-routine-names fs/ncpfs/inode.c
--- a/fs/ncpfs/inode.c~ncpfs-update-diagnostic-strings-to-match-routine-names
+++ a/fs/ncpfs/inode.c
@@ -987,7 +987,7 @@ static struct file_system_type ncp_fs_ty
 static int __init init_ncp_fs(void)
 {
 	int err;
-	DPRINTK("ncpfs: init_module called\n");
+	DPRINTK("ncpfs: init_ncp_fs called\n");
 
 	err = init_inodecache();
 	if (err)
@@ -1004,7 +1004,7 @@ out1:
 
 static void __exit exit_ncp_fs(void)
 {
-	DPRINTK("ncpfs: cleanup_module called\n");
+	DPRINTK("ncpfs: exit_ncp_fs called\n");
 	unregister_filesystem(&ncp_fs_type);
 	destroy_inodecache();
 }
_

Patches currently in -mm which might be from rpjday@crashcourse.ca are

git-arm.patch
git-hwmon.patch
git-mips.patch
pcmcia-net-use-roundup_pow_of_two-macro-instead-of-grotesque-loop.patch
blackfin-typo-config_rtc_bfin_module.patch
git-nfsd.patch
frv-move-dma-macros-to-scatterlisth-for-consistency.patch
m68knommu-remove-vestiges-of-non-existent-disktel.patch
uml-delete-some-unused-headers.patch
rd-use-is_power_of_2-in-drivers-block-rdc.patch
log2h-define-order_base_2-macro-for-convenience.patch
a-few-corrections-to-include-linux-kbuild.patch
ncpfs-update-diagnostic-strings-to-match-routine-names.patch
rtc-s3c-use-is_power_of_2-macro-for-simplicity.patch
hfs-update-comment-to-reflect-actual-init-and-exit.patch
irda-clean-up-superfluous-and-self-evident-comments.patch
