From: akpm@linux-foundation.org
Subject: [merged] maintainers-remove-include-linux-ext3.patch removed from -mm tree
Date: Tue, 18 Dec 2012 12:03:37 -0800
Message-ID: <20121218200338.1969120004E@hpza10.eem.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-wi0-f202.google.com ([209.85.212.202]:64389 "EHLO
	mail-wi0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753636Ab2LRUDk (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 18 Dec 2012 15:03:40 -0500
Received: by mail-wi0-f202.google.com with SMTP id hn17so63197wib.1
        for <mm-commits@vger.kernel.org>; Tue, 18 Dec 2012 12:03:39 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: cesarb@cesarb.net, jack@suse.cz, mm-commits@vger.kernel.org


The patch titled
     Subject: MAINTAINERS: remove include/linux/ext3*
has been removed from the -mm tree.  Its filename was
     maintainers-remove-include-linux-ext3.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Cesar Eduardo Barros <cesarb@cesarb.net>
Subject: MAINTAINERS: remove include/linux/ext3*

Moved to fs/ext3/ext3.h by commit 4613ad1 (ext3: move headers to
fs/ext3/).

Signed-off-by: Cesar Eduardo Barros <cesarb@cesarb.net>
Cc: Jan Kara <jack@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 MAINTAINERS |    2 --
 1 file changed, 2 deletions(-)

diff -puN MAINTAINERS~maintainers-remove-include-linux-ext3 MAINTAINERS
--- a/MAINTAINERS~maintainers-remove-include-linux-ext3
+++ a/MAINTAINERS
@@ -2982,7 +2982,6 @@ L:	linux-ext4@vger.kernel.org
 S:	Maintained
 F:	Documentation/filesystems/ext3.txt
 F:	fs/ext3/
-F:	include/linux/ext3*
 
 EXT4 FILE SYSTEM
 M:	"Theodore Ts'o" <tytso@mit.edu>
@@ -4314,7 +4313,6 @@ M:	Jan Kara <jack@suse.cz>
 L:	linux-ext4@vger.kernel.org
 S:	Maintained
 F:	fs/jbd/
-F:	include/linux/ext3_jbd.h
 F:	include/linux/jbd.h
 
 JOURNALLING LAYER FOR BLOCK DEVICES (JBD2)
_

Patches currently in -mm which might be from cesarb@cesarb.net are

origin.patch
linux-next.patch

