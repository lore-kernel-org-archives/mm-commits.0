From: akpm@linux-foundation.org
Subject: + maintainers-trim-the-file-triggers-for-abi-api.patch added to
 -mm tree
Date: Thu, 04 Feb 2016 11:20:07 -0800
Message-ID: <56b3a467.nYr9vSm6wqw7sFbW%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:42832 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965613AbcBDTUI (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 4 Feb 2016 14:20:08 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mtk.manpages@gmail.com, josh@joshtriplett.org, mtk.man-pages@gmail.com, shuahkh@osg.samsung.com, mm-commits@vger.kernel.org


The patch titled
     Subject: MAINTAINERS: trim the file triggers for ABI/API
has been added to the -mm tree.  Its filename is
     maintainers-trim-the-file-triggers-for-abi-api.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/maintainers-trim-the-file-triggers-for-abi-api.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/maintainers-trim-the-file-triggers-for-abi-api.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: "Michael Kerrisk (man-pages)" <mtk.manpages@gmail.com>
Subject: MAINTAINERS: trim the file triggers for ABI/API

Commit ea8f8fc8631 ("MAINTAINERS: add linux-api for review of API/ABI
changes") added file triggers for various paths that likely indicated
API/ABI changes.  However, catching all changes in Documentation/ABI/ and
include/uapi/ produces a large volume of mail to linux-api, rather than
only API/ABI changes.  Drop those two entries, but leave
include/linux/syscalls.h and kernel/sys_ni.c to catch syscall-related
changes.

[josh@joshtriplett.org: redid changelog]
Signed-off-by: Michael Kerrisk <mtk.man-pages@gmail.com>
Acked-by: Shuah khan <shuahkh@osg.samsung.com>
Cc: Josh Triplett <josh@joshtriplett.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 MAINTAINERS |    2 --
 1 file changed, 2 deletions(-)

diff -puN MAINTAINERS~maintainers-trim-the-file-triggers-for-abi-api MAINTAINERS
--- a/MAINTAINERS~maintainers-trim-the-file-triggers-for-abi-api
+++ a/MAINTAINERS
@@ -223,9 +223,7 @@ F:	drivers/scsi/aacraid/
 
 ABI/API
 L:	linux-api@vger.kernel.org
-F:	Documentation/ABI/
 F:	include/linux/syscalls.h
-F:	include/uapi/
 F:	kernel/sys_ni.c
 
 ABIT UGURU 1,2 HARDWARE MONITOR DRIVER
_

Patches currently in -mm which might be from mtk.manpages@gmail.com are

maintainers-trim-the-file-triggers-for-abi-api.patch

