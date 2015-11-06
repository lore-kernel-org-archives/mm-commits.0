From: akpm@linux-foundation.org
Subject: [merged] mm-fix-docbook-comment-for-get_vaddr_frames.patch
 removed from -mm tree
Date: Fri, 06 Nov 2015 12:07:30 -0800
Message-ID: <563d0882.HDkWVGKtAQcn2Doz%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:48666 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1032021AbbKFUHa (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 6 Nov 2015 15:07:30 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: corbet@lwn.net, jack@suse.cz, mm-commits@vger.kernel.org


The patch titled
     Subject: mm: fix docbook comment for get_vaddr_frames()
has been removed from the -mm tree.  Its filename was
     mm-fix-docbook-comment-for-get_vaddr_frames.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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


