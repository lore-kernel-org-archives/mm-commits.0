From: akpm@linux-foundation.org
Subject: + maintainers-add-git-url-entry-for-uio.patch added to -mm tree
Date: Mon, 12 Jan 2015 16:24:05 -0800
Message-ID: <54b465a5.ArgKeAq3BkkLl1Iz%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:37600 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752498AbbAMAYH (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 12 Jan 2015 19:24:07 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mandeep.sandhu@cyaninc.com, gregkh@linuxfoundation.org, hjk@hansjkoch.de, mm-commits@vger.kernel.org


The patch titled
     Subject: MAINTAINERS: add git url entry for UIO
has been added to the -mm tree.  Its filename is
     maintainers-add-git-url-entry-for-uio.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/maintainers-add-git-url-entry-for-uio.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/maintainers-add-git-url-entry-for-uio.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Mandeep Sandhu <mandeep.sandhu@cyaninc.com>
Subject: MAINTAINERS: add git url entry for UIO

Added git url for UIO section.

Signed-off-by: Mandeep Sandhu <mandeep.sandhu@cyaninc.com>
Cc: "Hans J. Koch" <hjk@hansjkoch.de>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 MAINTAINERS |    1 +
 1 file changed, 1 insertion(+)

diff -puN MAINTAINERS~maintainers-add-git-url-entry-for-uio MAINTAINERS
--- a/MAINTAINERS~maintainers-add-git-url-entry-for-uio
+++ a/MAINTAINERS
@@ -10201,6 +10201,7 @@ USERSPACE I/O (UIO)
 M:	"Hans J. Koch" <hjk@hansjkoch.de>
 M:	Greg Kroah-Hartman <gregkh@linuxfoundation.org>
 S:	Maintained
+T:	git git://git.kernel.org/pub/scm/linux/kernel/git/gregkh/char-misc.git
 F:	Documentation/DocBook/uio-howto.tmpl
 F:	drivers/uio/
 F:	include/linux/uio*.h
_

Patches currently in -mm which might be from mandeep.sandhu@cyaninc.com are

maintainers-add-git-url-entry-for-uio.patch

