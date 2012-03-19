From: akpm@linux-foundation.org
Subject: + fs-dcachec-fix-kernel-doc-warnings.patch added to -mm tree
Date: Mon, 19 Mar 2012 16:21:02 -0700
Message-ID: <20120319232102.C0407A03A5@akpm.mtv.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-lb0-f202.google.com ([209.85.217.202]:50372 "EHLO
	mail-lb0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758470Ab2CSXVG (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 19 Mar 2012 19:21:06 -0400
Received: by lbbgj3 with SMTP id gj3so234070lbb.1
        for <mm-commits@vger.kernel.org>; Mon, 19 Mar 2012 16:21:04 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: rdunlap@xenotime.net


The patch titled
     Subject: fs/dcache.c: fix kernel-doc warnings
has been added to the -mm tree.  Its filename is
     fs-dcachec-fix-kernel-doc-warnings.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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
@@ -1690,7 +1690,7 @@ EXPORT_SYMBOL(d_add_ci);
  * __d_lookup_rcu - search for a dentry (racy, store-free)
  * @parent: parent dentry
  * @name: qstr of name we wish to find
- * @seq: returns d_seq value at the point where the dentry was found
+ * @seqp: returns d_seq value at the point where the dentry was found
  * @inode: returns dentry->d_inode when the inode was found valid.
  * Returns: dentry, or NULL
  *
_
Subject: Subject: fs/dcache.c: fix kernel-doc warnings

Patches currently in -mm which might be from rdunlap@xenotime.net are

linux-next.patch
fs-symlink-restrictions-on-sticky-directories.patch
fs-hardlink-creation-restrictions.patch
remove-remaining-bits-of-io_remap_page_range.patch
fs-dcachec-fix-kernel-doc-warnings.patch
backlight-fix-ot200_bl-build.patch
crc32-bolt-on-crc32c-dont-reference-unnecessary-crc32-tables-in-single-bit-mode.patch
rtc-ds1307-generalise-ram-size-and-offset-fix.patch
syscalls-x86-add-__nr_kcmp-syscall-v8-fix.patch
syscalls-x86-add-__nr_kcmp-syscall-v8-fix-2.patch
ramoops-use-pstore-interface.patch
ramoops-use-pstore-interface-fix.patch
mutex-subsystem-synchro-test-module.patch
mutex-subsystem-synchro-test-module-fix.patch

