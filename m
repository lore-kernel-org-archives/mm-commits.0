From: akpm@linux-foundation.org
Subject: + maintainers-update-partitions-block-f-patterns.patch added to -mm tree
Date: Fri, 20 Jan 2012 14:40:53 -0800
Message-ID: <20120120224054.2B01F1E0058@wpzn4.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-gy0-f202.google.com ([209.85.160.202]:48717 "EHLO
	mail-gy0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755708Ab2ATWky (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 20 Jan 2012 17:40:54 -0500
Received: by ghbg20 with SMTP id g20so86931ghb.1
        for <mm-commits@vger.kernel.org>; Fri, 20 Jan 2012 14:40:54 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: joe@perches.com, viro@zeniv.linux.org.uk


The patch titled
     Subject: MAINTAINERS: update partitions block F: patterns
has been added to the -mm tree.  Its filename is
     maintainers-update-partitions-block-f-patterns.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Joe Perches <joe@perches.com>
Subject: MAINTAINERS: update partitions block F: patterns

Commit 9be96f3fd101 ("move fs/partitions to block/") moved the files,
update the patterns.

Signed-off-by: Joe Perches <joe@perches.com>
Cc: Al Viro <viro@zeniv.linux.org.uk>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 MAINTAINERS |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff -puN MAINTAINERS~maintainers-update-partitions-block-f-patterns MAINTAINERS
--- a/MAINTAINERS~maintainers-update-partitions-block-f-patterns
+++ a/MAINTAINERS
@@ -4122,7 +4122,7 @@ L:	linux-ntfs-dev@lists.sourceforge.net
 W:	http://www.linux-ntfs.org/content/view/19/37/
 S:	Maintained
 F:	Documentation/ldm.txt
-F:	fs/partitions/ldm.*
+F:	block/partitions/ldm.*
 
 LogFS
 M:	Joern Engel <joern@logfs.org>
@@ -5625,7 +5625,7 @@ W:	http://www.ibm.com/developerworks/lin
 S:	Supported
 F:	arch/s390/
 F:	drivers/s390/
-F:	fs/partitions/ibm.c
+F:	block/partitions/ibm.c
 F:	Documentation/s390/
 F:	Documentation/DocBook/s390*
 
_
Subject: Subject: MAINTAINERS: update partitions block F: patterns

Patches currently in -mm which might be from joe@perches.com are

maintainers-update-partitions-block-f-patterns.patch
maintainers-remove-imx5-section.patch
maintainers-remove-staging-sections.patch
maintainers-update-lguest-f-patterns.patch
linux-next.patch
maintainers-staging-cx25821-add-l-linux-media.patch

