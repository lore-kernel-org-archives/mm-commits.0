From: akpm@linux-foundation.org
Subject: - ext3-remove-unused-code-from-ext3_find_entry.patch removed from -mm tree
Date: Wed, 06 Feb 2008 16:30:52 -0800
Message-ID: <200802070030.m170UXug007402@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:44351 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1765960AbYBGAmf (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 6 Feb 2008 19:42:35 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: m.kozlowski@tuxland.pl, mm-commits@vger.kernel.org


The patch titled
     ext3: remove unused code from ext3_find_entry()
has been removed from the -mm tree.  Its filename was
     ext3-remove-unused-code-from-ext3_find_entry.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: ext3: remove unused code from ext3_find_entry()
From: Mariusz Kozlowski <m.kozlowski@tuxland.pl>

Signed-off-by: Mariusz Kozlowski <m.kozlowski@tuxland.pl>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/ext3/namei.c |    4 ----
 1 file changed, 4 deletions(-)

diff -puN fs/ext3/namei.c~ext3-remove-unused-code-from-ext3_find_entry fs/ext3/namei.c
--- a/fs/ext3/namei.c~ext3-remove-unused-code-from-ext3_find_entry
+++ a/fs/ext3/namei.c
@@ -860,14 +860,10 @@ static struct buffer_head * ext3_find_en
 	int nblocks, i, err;
 	struct inode *dir = dentry->d_parent->d_inode;
 	int namelen;
-	const u8 *name;
-	unsigned blocksize;
 
 	*res_dir = NULL;
 	sb = dir->i_sb;
-	blocksize = sb->s_blocksize;
 	namelen = dentry->d_name.len;
-	name = dentry->d_name.name;
 	if (namelen > EXT3_NAME_LEN)
 		return NULL;
 	if (is_dx(dir)) {
_

Patches currently in -mm which might be from m.kozlowski@tuxland.pl are

origin.patch
git-mmc.patch
pid-fix-mips-irix-emulation-pid-usage-fix.patch
reiser4.patch
