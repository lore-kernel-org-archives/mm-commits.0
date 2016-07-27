From: akpm@linux-foundation.org
Subject: + maintainers-befs-add-new-maintainers.patch added to -mm tree
Date: Wed, 27 Jul 2016 13:44:51 -0700
Message-ID: <57991d43.jtnX5x8aRu0eTTIa%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:43545 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932318AbcG0Uow (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 27 Jul 2016 16:44:52 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: luisbg@osg.samsung.com, gregkh@linuxfoundation.org, tytso@mit.edu, mm-commits@vger.kernel.org


The patch titled
     Subject: MAINTAINERS: befs: add new maintainers
has been added to the -mm tree.  Its filename is
     maintainers-befs-add-new-maintainers.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/maintainers-befs-add-new-maintainers.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/maintainers-befs-add-new-maintainers.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Luis de Bethencourt <luisbg@osg.samsung.com>
Subject: MAINTAINERS: befs: add new maintainers

Salah Triki and Luis de Bethencourt are taking over maintainership of befs.

Link: http://lkml.kernel.org/r/1469651079-32455-1-git-send-email-luisbg@osg.samsung.com
Signed-off-by: Luis de Bethencourt <luisbg@osg.samsung.com>
Acked-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Acked-by: Theodore Ts'o <tytso@mit.edu>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 MAINTAINERS |    5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff -puN MAINTAINERS~maintainers-befs-add-new-maintainers MAINTAINERS
--- a/MAINTAINERS~maintainers-befs-add-new-maintainers
+++ a/MAINTAINERS
@@ -2351,7 +2351,10 @@ S:	Supported
 F:	drivers/media/platform/sti/bdisp
 
 BEFS FILE SYSTEM
-S:	Orphan
+M:	Luis de Bethencourt <luisbg@osg.samsung.com>
+M:	Salah Triki <salah.triki@gmail.com>
+S:	Maintained
+T:	git git://github.com/luisbg/linux-befs.git
 F:	Documentation/filesystems/befs.txt
 F:	fs/befs/
 
_

Patches currently in -mm which might be from luisbg@osg.samsung.com are

dynamic_debug-only-add-header-when-used.patch
dynamic_debug-only-add-header-when-used-fix.patch
maintainers-befs-add-new-maintainers.patch
befs-check-return-of-sb_min_blocksize.patch
befs-fix-function-name-in-documentation.patch
befs-remove-unused-functions.patch

