From: akpm@linux-foundation.org
Subject: [merged] fs-befs-kernel-doc-fixes.patch removed from -mm tree
Date: Mon, 09 Jun 2014 12:31:17 -0700
Message-ID: <53960b85.awVFzbMc7DXBk8IU%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:53873 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750956AbaFITbR (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 9 Jun 2014 15:31:17 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, rdunlap@infradead.org, fabf@skynet.be

Subject: [merged] fs-befs-kernel-doc-fixes.patch removed from -mm tree
To: fabf@skynet.be,rdunlap@infradead.org,mm-commits@vger.kernel.org
From: akpm@linux-foundation.org
Date: Mon, 09 Jun 2014 12:31:17 -0700


The patch titled
     Subject: fs/befs: kernel-doc fixes
has been removed from the -mm tree.  Its filename was
     fs-befs-kernel-doc-fixes.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Fabian Frederick <fabf@skynet.be>
Subject: fs/befs: kernel-doc fixes

Fix some comment errors.

Signed-off-by: Fabian Frederick <fabf@skynet.be>
Cc: Randy Dunlap <rdunlap@infradead.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/befs/btree.c      |    4 ++--
 fs/befs/datastream.c |    2 +-
 fs/befs/linuxvfs.c   |   16 ++++++++--------
 3 files changed, 11 insertions(+), 11 deletions(-)

diff -puN fs/befs/btree.c~fs-befs-kernel-doc-fixes fs/befs/btree.c
--- a/fs/befs/btree.c~fs-befs-kernel-doc-fixes
+++ a/fs/befs/btree.c
@@ -318,7 +318,7 @@ befs_btree_find(struct super_block *sb,
  * befs_find_key - Search for a key within a node
  * @sb: Filesystem superblock
  * @node: Node to find the key within
- * @key: Keystring to search for
+ * @findkey: Keystring to search for
  * @value: If key is found, the value stored with the key is put here
  *
  * finds exact match if one exists, and returns BEFS_BT_MATCH
@@ -706,7 +706,7 @@ befs_bt_get_key(struct super_block *sb,
  * @key1: pointer to the first key to be compared 
  * @keylen1: length in bytes of key1
  * @key2: pointer to the second key to be compared
- * @kelen2: length in bytes of key2
+ * @keylen2: length in bytes of key2
  *
  * Returns 0 if @key1 and @key2 are equal.
  * Returns >0 if @key1 is greater.
diff -puN fs/befs/datastream.c~fs-befs-kernel-doc-fixes fs/befs/datastream.c
--- a/fs/befs/datastream.c~fs-befs-kernel-doc-fixes
+++ a/fs/befs/datastream.c
@@ -116,7 +116,7 @@ befs_fblock2brun(struct super_block *sb,
  * befs_read_lsmylink - read long symlink from datastream.
  * @sb: Filesystem superblock 
  * @ds: Datastrem to read from
- * @buf: Buffer in which to place long symlink data
+ * @buff: Buffer in which to place long symlink data
  * @len: Length of the long symlink in bytes
  *
  * Returns the number of bytes read
diff -puN fs/befs/linuxvfs.c~fs-befs-kernel-doc-fixes fs/befs/linuxvfs.c
--- a/fs/befs/linuxvfs.c~fs-befs-kernel-doc-fixes
+++ a/fs/befs/linuxvfs.c
@@ -582,21 +582,21 @@ befs_utf2nls(struct super_block *sb, con
 /**
  * befs_nls2utf - Convert NLS string to utf8 encodeing
  * @sb: Superblock
- * @src: Input string buffer in NLS format
- * @srclen: Length of input string in bytes
- * @dest: The output string in UTF-8 format
- * @destlen: Length of the output buffer
+ * @in: Input string buffer in NLS format
+ * @in_len: Length of input string in bytes
+ * @out: The output string in UTF-8 format
+ * @out_len: Length of the output buffer
  * 
- * Converts input string @src, which is in the format of the loaded NLS map,
+ * Converts input string @in, which is in the format of the loaded NLS map,
  * into a utf8 string.
  * 
- * The destination string @dest is allocated by this function and the caller is
+ * The destination string @out is allocated by this function and the caller is
  * responsible for freeing it with kfree()
  * 
- * On return, *@destlen is the length of @dest in bytes.
+ * On return, *@out_len is the length of @out in bytes.
  *
  * On success, the return value is the number of utf8 characters written to
- * the output buffer @dest.
+ * the output buffer @out.
  *  
  * On Failure, a negative number coresponding to the error code is returned.
  */
_

Patches currently in -mm which might be from fabf@skynet.be are

origin.patch
fs-cifs-remove-obsolete-__constant.patch
kernel-posix-timersc-code-clean-up.patch
kernel-posix-timersc-code-clean-up-checkpatch-fixes.patch
fs-ext4-fsyncc-generic_file_fsync-call-based-on-barrier-flag.patch
fs-isofs-logging-clean-up.patch
linux-next.patch
kernel-watchdogc-convert-printk-pr_warning-to-pr_foo.patch
init-mainc-code-clean-up.patch
kernel-kprobesc-convert-printk-to-pr_foo.patch

