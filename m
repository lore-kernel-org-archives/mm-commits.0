From: akpm@linux-foundation.org
Subject: + init-do_mountsc-fix-comment-error.patch added to -mm tree
Date: Wed, 12 Feb 2014 14:18:19 -0800
Message-ID: <52fbf32b.xwz1n9VNUJMwmUc5%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:53027 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753426AbaBLWSU (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 12 Feb 2014 17:18:20 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, chishanmingshen@gmail.com

Subject: + init-do_mountsc-fix-comment-error.patch added to -mm tree
To: chishanmingshen@gmail.com
From: akpm@linux-foundation.org
Date: Wed, 12 Feb 2014 14:18:19 -0800


The patch titled
     Subject: init/do_mounts.c: fix comment error
has been added to the -mm tree.  Its filename is
     init-do_mountsc-fix-comment-error.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/init-do_mountsc-fix-comment-error.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/init-do_mountsc-fix-comment-error.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: chishanmingshen <chishanmingshen@gmail.com>
Subject: init/do_mounts.c: fix comment error

Signed-off-by: chishanmingshen <chishanmingshen@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 init/do_mounts.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff -puN init/do_mounts.c~init-do_mountsc-fix-comment-error init/do_mounts.c
--- a/init/do_mounts.c~init-do_mountsc-fix-comment-error
+++ a/init/do_mounts.c
@@ -102,13 +102,13 @@ no_match:
 
 /**
  * devt_from_partuuid - looks up the dev_t of a partition by its UUID
- * @uuid:	char array containing ascii UUID
+ * @uuid_str:	char array containing ascii UUID
  *
  * The function will return the first partition which contains a matching
  * UUID value in its partition_meta_info struct.  This does not search
  * by filesystem UUIDs.
  *
- * If @uuid is followed by a "/PARTNROFF=%d", then the number will be
+ * If @uuid_str is followed by a "/PARTNROFF=%d", then the number will be
  * extracted and used as an offset from the partition identified by the UUID.
  *
  * Returns the matching dev_t on success or 0 on failure.
_

Patches currently in -mm which might be from chishanmingshen@gmail.com are

init-do_mountsc-fix-comment-error.patch

