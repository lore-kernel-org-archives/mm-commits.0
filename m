From: akpm@linux-foundation.org
Subject: [merged] init-do_mountsc-add-maj-min-syntax-comment.patch removed from -mm tree
Date: Wed, 13 Nov 2013 12:39:54 -0800
Message-ID: <5283e39a.KW34Bx/FVOntOmKJ%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:42862 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751663Ab3KMUjy (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 13 Nov 2013 15:39:54 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, sebastian.capella@linaro.org

Subject: [merged] init-do_mountsc-add-maj-min-syntax-comment.patch removed from -mm tree
To: sebastian.capella@linaro.org,mm-commits@vger.kernel.org
From: akpm@linux-foundation.org
Date: Wed, 13 Nov 2013 12:39:54 -0800


The patch titled
     Subject: init/do_mounts.c: add maj:min syntax comment
has been removed from the -mm tree.  Its filename was
     init-do_mountsc-add-maj-min-syntax-comment.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Sebastian Capella <sebastian.capella@linaro.org>
Subject: init/do_mounts.c: add maj:min syntax comment

The name_to_dev_t function has a comment block which lists the supported
syntaxes for the device name.  Add a bullet for the <major>:<minor>
syntax, which is already supported in the code

Signed-off-by: Sebastian Capella <sebastian.capella@linaro.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 init/do_mounts.c |    2 ++
 1 file changed, 2 insertions(+)

diff -puN init/do_mounts.c~init-do_mountsc-add-maj-min-syntax-comment init/do_mounts.c
--- a/init/do_mounts.c~init-do_mountsc-add-maj-min-syntax-comment
+++ a/init/do_mounts.c
@@ -197,6 +197,8 @@ done:
  *	   is a zero-filled hex representation of the 1-based partition number.
  *	7) PARTUUID=<UUID>/PARTNROFF=<int> to select a partition in relation to
  *	   a partition with a known unique id.
+ *	8) <major>:<minor> major and minor number of the device separated by
+ *	   a colon.
  *
  *	If name doesn't have fall into the categories above, we return (0,0).
  *	block_class is used to check if something is a disk name. If the disk
_

Patches currently in -mm which might be from sebastian.capella@linaro.org are

origin.patch

