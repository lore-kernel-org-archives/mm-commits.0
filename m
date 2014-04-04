From: akpm@linux-foundation.org
Subject: [merged] init-do_mountsc-fix-comment-error.patch removed from -mm tree
Date: Fri, 04 Apr 2014 12:34:38 -0700
Message-ID: <533f094e.SC+2S8VHEMN9+6Tf%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:43448 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754352AbaDDTei (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 4 Apr 2014 15:34:38 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, chishanmingshen@gmail.com

Subject: [merged] init-do_mountsc-fix-comment-error.patch removed from -mm tree
To: chishanmingshen@gmail.com,mm-commits@vger.kernel.org
From: akpm@linux-foundation.org
Date: Fri, 04 Apr 2014 12:34:38 -0700


The patch titled
     Subject: init/do_mounts.c: fix comment error
has been removed from the -mm tree.  Its filename was
     init-do_mountsc-fix-comment-error.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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

origin.patch

