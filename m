From: akpm@linux-foundation.org
Subject: [merged] documentation-remove-reference-to-feature-removal-scheduletxt.patch removed from -mm tree
Date: Tue, 18 Dec 2012 12:02:39 -0800
Message-ID: <20121218200239.96CFD82004A@wpzn4.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-vb0-f73.google.com ([209.85.212.73]:37503 "EHLO
	mail-vb0-f73.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751357Ab2LRUCk (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 18 Dec 2012 15:02:40 -0500
Received: by mail-vb0-f73.google.com with SMTP id l1so125221vba.0
        for <mm-commits@vger.kernel.org>; Tue, 18 Dec 2012 12:02:40 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: boyu.mt@taobao.com, mm-commits@vger.kernel.org


The patch titled
     Subject: Documentation: remove reference to feature-removal-schedule.txt
has been removed from the -mm tree.  Its filename was
     documentation-remove-reference-to-feature-removal-scheduletxt.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Tao Ma <boyu.mt@taobao.com>
Subject: Documentation: remove reference to feature-removal-schedule.txt

In 9c0ece069, Linus removed feature-removal-schedule.txt from Documentation,
but there is still some reference to this file. So remove them.

Signed-off-by: Tao Ma <boyu.mt@taobao.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/00-INDEX   |    2 --
 Documentation/ABI/README |    3 ---
 2 files changed, 5 deletions(-)

diff -puN Documentation/00-INDEX~documentation-remove-reference-to-feature-removal-scheduletxt Documentation/00-INDEX
--- a/Documentation/00-INDEX~documentation-remove-reference-to-feature-removal-scheduletxt
+++ a/Documentation/00-INDEX
@@ -136,8 +136,6 @@ fault-injection/
 	- dir with docs about the fault injection capabilities infrastructure.
 fb/
 	- directory with info on the frame buffer graphics abstraction layer.
-feature-removal-schedule.txt
-	- list of files and features that are going to be removed.
 filesystems/
 	- info on the vfs and the various filesystems that Linux supports.
 firmware_class/
diff -puN Documentation/ABI/README~documentation-remove-reference-to-feature-removal-scheduletxt Documentation/ABI/README
--- a/Documentation/ABI/README~documentation-remove-reference-to-feature-removal-scheduletxt
+++ a/Documentation/ABI/README
@@ -36,9 +36,6 @@ The different levels of stability are:
 	the kernel, but are marked to be removed at some later point in
 	time.  The description of the interface will document the reason
 	why it is obsolete and when it can be expected to be removed.
-	The file Documentation/feature-removal-schedule.txt may describe
-	some of these interfaces, giving a schedule for when they will
-	be removed.
 
   removed/
 	This directory contains a list of the old interfaces that have
_

Patches currently in -mm which might be from boyu.mt@taobao.com are

origin.patch

