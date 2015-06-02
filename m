From: akpm@linux-foundation.org
Subject: + fsnotify-remove-obsolete-documentation.patch added to -mm tree
Date: Tue, 02 Jun 2015 13:47:11 -0700
Message-ID: <556e164f.Nk0/VgiLdriEiDtu%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:45765 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751122AbbFBUrM (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 2 Jun 2015 16:47:12 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: kernel@kyup.com, jack@suse.cz, mm-commits@vger.kernel.org


The patch titled
     Subject: fsnotify: remove obsolete documentation
has been added to the -mm tree.  Its filename is
     fsnotify-remove-obsolete-documentation.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/fsnotify-remove-obsolete-documentation.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/fsnotify-remove-obsolete-documentation.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Nikolay Borisov <kernel@kyup.com>
Subject: fsnotify: remove obsolete documentation

should_send_event is no longer part of struct fsnotify_ops, so remove it.

Signed-off-by: Nikolay Borisov <kernel@kyup.com>
Reviewed-by: Jan Kara <jack@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/fsnotify_backend.h |    2 --
 1 file changed, 2 deletions(-)

diff -puN include/linux/fsnotify_backend.h~fsnotify-remove-obsolete-documentation include/linux/fsnotify_backend.h
--- a/include/linux/fsnotify_backend.h~fsnotify-remove-obsolete-documentation
+++ a/include/linux/fsnotify_backend.h
@@ -84,8 +84,6 @@ struct fsnotify_fname;
  * Each group much define these ops.  The fsnotify infrastructure will call
  * these operations for each relevant group.
  *
- * should_send_event - given a group, inode, and mask this function determines
- *		if the group is interested in this event.
  * handle_event - main call for a group to handle an fs event
  * free_group_priv - called when a group refcnt hits 0 to clean up the private union
  * freeing_mark - called when a mark is being destroyed for some reason.  The group
_

Patches currently in -mm which might be from kernel@kyup.com are

fsnotify-remove-obsolete-documentation.patch
linux-next.patch

