From: akpm@linux-foundation.org
Subject: + maintainers-remove-include-linux-ext3.patch added to -mm tree
Date: Tue, 27 Nov 2012 12:42:46 -0800
Message-ID: <20121127204246.B7C68100047@wpzn3.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-vb0-f74.google.com ([209.85.212.74]:62878 "EHLO
	mail-vb0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752039Ab2K0Umr (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 27 Nov 2012 15:42:47 -0500
Received: by mail-vb0-f74.google.com with SMTP id s24so1522362vbi.1
        for <mm-commits@vger.kernel.org>; Tue, 27 Nov 2012 12:42:47 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: cesarb@cesarb.net, jack@suse.cz


The patch titled
     Subject: MAINTAINERS: remove include/linux/ext3*
has been added to the -mm tree.  Its filename is
     maintainers-remove-include-linux-ext3.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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
@@ -2973,7 +2973,6 @@ L:	linux-ext4@vger.kernel.org
 S:	Maintained
 F:	Documentation/filesystems/ext3.txt
 F:	fs/ext3/
-F:	include/linux/ext3*
 
 EXT4 FILE SYSTEM
 M:	"Theodore Ts'o" <tytso@mit.edu>
@@ -4300,7 +4299,6 @@ M:	Jan Kara <jack@suse.cz>
 L:	linux-ext4@vger.kernel.org
 S:	Maintained
 F:	fs/jbd/
-F:	include/linux/ext3_jbd.h
 F:	include/linux/jbd.h
 
 JOURNALLING LAYER FOR BLOCK DEVICES (JBD2)
_

Patches currently in -mm which might be from cesarb@cesarb.net are

linux-next.patch
mm-refactor-reinsert-of-swap_info-in-sys_swapoff.patch
mm-do-not-call-frontswap_init-during-swapoff.patch
maintainers-remove-include-linux-ext3.patch

