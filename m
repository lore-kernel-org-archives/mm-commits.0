From: akpm@linux-foundation.org
Subject: + listh-fix-fatal-kernel-doc-error.patch added to -mm tree
Date: Mon, 11 Aug 2008 16:35:53 -0700
Message-ID: <200808112335.m7BNZrhq027881@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:42597 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753243AbYHKXgh (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 11 Aug 2008 19:36:37 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: randy.dunlap@oracle.com


The patch titled
     list.h: fix fatal kernel-doc error
has been added to the -mm tree.  Its filename is
     listh-fix-fatal-kernel-doc-error.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: list.h: fix fatal kernel-doc error
From: Randy Dunlap <randy.dunlap@oracle.com>

Fix fatal multi-line kernel-doc error in list.h:
function short description must be on one line.

Error(linux-2.6.27-rc2-git3//include/linux/list.h:318): duplicate section name 'Description'

Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/list.h |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff -puN include/linux/list.h~listh-fix-fatal-kernel-doc-error include/linux/list.h
--- a/include/linux/list.h~listh-fix-fatal-kernel-doc-error
+++ a/include/linux/list.h
@@ -309,11 +309,11 @@ static inline void list_splice_init(stru
 }
 
 /**
- * list_splice_tail_init - join two lists, each list being a queue, and
- *     reinitialise the emptied list.
+ * list_splice_tail_init - join two lists and reinitialise the emptied list
  * @list: the new list to add.
  * @head: the place to add it in the first list.
  *
+ * Each of the lists is a queue.
  * The list at @list is reinitialised
  */
 static inline void list_splice_tail_init(struct list_head *list,
_

Patches currently in -mm which might be from randy.dunlap@oracle.com are

origin.patch
gru-fix-preprocessor-symbol-for-sparse.patch
pci-calgary-fix-function-declaration.patch
move-kernel-doc-comment-for-might_sleep-directly-before-its-defining-block.patch
listh-fix-fatal-kernel-doc-error.patch
linux-next.patch
drm-sis-depends-on-fb_sis.patch
genksyms-track-symbol-checksum-changes.patch
genksyms-allow-to-ignore-symbol-checksum-changes.patch
lkdtm-fix-for-config_scsi=n.patch
e1000e-make-e1000e-default-to-the-same-kconfig-setting-as-e1000.patch
netfilter-conntrack_helper-needs-to-include-rculisth.patch
ftrace-printk-formatting-infrastructure-fix.patch
git-unionfs.patch
docsrc-build-documentation-sources.patch
docsrc-fix-procfs-example.patch
docsrc-fix-ifenslave-type.patch
docsrc-fix-crc32hash-type.patch
docsrc-fix-getdelays-printk-formats.patch
rcu-fix-synchronize_rcu-so-that-kernel-doc-works.patch
w1-documentation-w1-masters-ds2490-update.patch
profile-likely-unlikely-macros.patch

