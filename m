From: akpm@linux-foundation.org
Subject: [merged] fs-dcachec-fix-kernel-doc-warnings.patch removed from -mm tree
Date: Fri, 23 Mar 2012 11:22:53 -0700
Message-ID: <20120323182253.4EEF1A080E@akpm.mtv.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-ey0-f202.google.com ([209.85.215.202]:43224 "EHLO
	mail-ey0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759253Ab2CWSW5 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 23 Mar 2012 14:22:57 -0400
Received: by eaaq10 with SMTP id q10so184073eaa.1
        for <mm-commits@vger.kernel.org>; Fri, 23 Mar 2012 11:22:54 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: rdunlap@xenotime.net, mm-commits@vger.kernel.org


The patch titled
     Subject: fs/dcache.c: fix kernel-doc warnings
has been removed from the -mm tree.  Its filename was
     fs-dcachec-fix-kernel-doc-warnings.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
From: Randy Dunlap <rdunlap@xenotime.net>
Subject: fs/dcache.c: fix kernel-doc warnings

Warning(fs/dcache.c:1743): No description found for parameter 'seqp'
Warning(fs/dcache.c:1743): Excess function parameter 'seq' description in '__d_lookup_rcu'

Signed-off-by: Randy Dunlap <rdunlap@xenotime.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/dcache.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN fs/dcache.c~fs-dcachec-fix-kernel-doc-warnings fs/dcache.c
--- a/fs/dcache.c~fs-dcachec-fix-kernel-doc-warnings
+++ a/fs/dcache.c
@@ -1713,7 +1713,7 @@ EXPORT_SYMBOL(d_add_ci);
  * __d_lookup_rcu - search for a dentry (racy, store-free)
  * @parent: parent dentry
  * @name: qstr of name we wish to find
- * @seq: returns d_seq value at the point where the dentry was found
+ * @seqp: returns d_seq value at the point where the dentry was found
  * @inode: returns dentry->d_inode when the inode was found valid.
  * Returns: dentry, or NULL
  *
_

Patches currently in -mm which might be from rdunlap@xenotime.net are

origin.patch
linux-next.patch
fs-symlink-restrictions-on-sticky-directories.patch
fs-hardlink-creation-restrictions.patch
remove-remaining-bits-of-io_remap_page_range.patch
backlight-fix-ot200_bl-build.patch
crc32-bolt-on-crc32c-dont-reference-unnecessary-crc32-tables-in-single-bit-mode.patch
rtc-ds1307-generalise-ram-size-and-offset-fix.patch
syscalls-x86-add-__nr_kcmp-syscall-v8-fix.patch
syscalls-x86-add-__nr_kcmp-syscall-v8-fix-2.patch
ramoops-use-pstore-interface.patch
ramoops-use-pstore-interface-fix.patch
mutex-subsystem-synchro-test-module.patch
mutex-subsystem-synchro-test-module-fix.patch

