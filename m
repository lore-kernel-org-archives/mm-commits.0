From: akpm@linux-foundation.org
Subject: + init-do_mountsc-add-maj-min-syntax-comment.patch added to -mm
 tree
Date: Mon, 23 Sep 2013 15:43:25 -0700
Message-ID: <5240c40d.4VxMPjONKkpQwj/r%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:56434 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752482Ab3IWWn0 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 23 Sep 2013 18:43:26 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, sebastian.capella@linaro.org

Subject: + init-do_mountsc-add-maj-min-syntax-comment.patch added to -mm tree
To: sebastian.capella@linaro.org
From: akpm@linux-foundation.org
Date: Mon, 23 Sep 2013 15:43:25 -0700


The patch titled
     Subject: init/do_mounts.c: add maj:min syntax comment
has been added to the -mm tree.  Its filename is
     init-do_mountsc-add-maj-min-syntax-comment.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/init-do_mountsc-add-maj-min-syntax-comment.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/init-do_mountsc-add-maj-min-syntax-comment.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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

init-do_mountsc-add-maj-min-syntax-comment.patch

