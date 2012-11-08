From: akpm@linux-foundation.org
Subject: + documentation-remove-reference-to-feature-removal-scheduletxt.patch added to -mm tree
Date: Thu, 08 Nov 2012 12:14:42 -0800
Message-ID: <20121108201443.2DEC4100047@wpzn3.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-gg0-f202.google.com ([209.85.161.202]:50906 "EHLO
	mail-gg0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756614Ab2KHUOo (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 8 Nov 2012 15:14:44 -0500
Received: by mail-gg0-f202.google.com with SMTP id i4so367489ggm.1
        for <mm-commits@vger.kernel.org>; Thu, 08 Nov 2012 12:14:44 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: boyu.mt@taobao.com


The patch titled
     Subject: Documentation: remove reference to feature-removal-schedule.txt
has been added to the -mm tree.  Its filename is
     documentation-remove-reference-to-feature-removal-scheduletxt.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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

documentation-remove-reference-to-feature-removal-scheduletxt.patch
kernel-remove-reference-to-feature-removal-scheduletxt.patch
sound-remove-reference-to-feature-removal-scheduletxt.patch
drivers-remove-reference-to-feature-removal-scheduletxt.patch

