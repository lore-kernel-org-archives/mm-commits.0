From: akpm@linux-foundation.org
Subject: + mm-fix-docbook-comment-for-get_vaddr_frames.patch added to -mm
 tree
Date: Mon, 14 Sep 2015 14:30:49 -0700
Message-ID: <55f73c89.hwcZact1M6ajdi4M%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:47409 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750980AbbINVat (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 14 Sep 2015 17:30:49 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: corbet@lwn.net, jack@suse.cz, mm-commits@vger.kernel.org


The patch titled
     Subject: mm: fix docbook comment for get_vaddr_frames()
has been added to the -mm tree.  Its filename is
     mm-fix-docbook-comment-for-get_vaddr_frames.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-fix-docbook-comment-for-get_vaddr_frames.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-fix-docbook-comment-for-get_vaddr_frames.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Jonathan Corbet <corbet@lwn.net>
Subject: mm: fix docbook comment for get_vaddr_frames()

get_vaddr_frames() has a comment that's *almost* a docbook comment; add
the missing star so that the tools will find it properly.

Signed-off-by: Jonathan Corbet <corbet@lwn.net>
Cc: Jan Kara <jack@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/frame_vector.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN mm/frame_vector.c~mm-fix-docbook-comment-for-get_vaddr_frames mm/frame_vector.c
--- a/mm/frame_vector.c~mm-fix-docbook-comment-for-get_vaddr_frames
+++ a/mm/frame_vector.c
@@ -7,7 +7,7 @@
 #include <linux/pagemap.h>
 #include <linux/sched.h>
 
-/*
+/**
  * get_vaddr_frames() - map virtual addresses to pfns
  * @start:	starting user address
  * @nr_frames:	number of pages / pfns from start to map
_

Patches currently in -mm which might be from corbet@lwn.net are

mm-fix-docbook-comment-for-get_vaddr_frames.patch

