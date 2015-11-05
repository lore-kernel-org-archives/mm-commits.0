From: akpm@linux-foundation.org
Subject: + maintainers-add-missing-extcon-directory.patch added to -mm
 tree
Date: Thu, 05 Nov 2015 02:21:35 -0800
Message-ID: <563b2daf.7WTLQJEV7HQjpaLi%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:56995 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1031067AbbKEKVg (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 5 Nov 2015 05:21:36 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: cw00.choi@samsung.com, mm-commits@vger.kernel.org


The patch titled
     Subject: MAINTAINERS: add missing extcon directory
has been added to the -mm tree.  Its filename is
     maintainers-add-missing-extcon-directory.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/maintainers-add-missing-extcon-directory.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/maintainers-add-missing-extcon-directory.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Chanwoo Choi <cw00.choi@samsung.com>
Subject: MAINTAINERS: add missing extcon directory

Add the missing extcon directory to maintain them.  When using
get_maintainer.pl, the result should include the correct maintainer
information.

Signed-off-by: Chanwoo Choi <cw00.choi@samsung.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 MAINTAINERS |    3 +++
 1 file changed, 3 insertions(+)

diff -puN MAINTAINERS~maintainers-add-missing-extcon-directory MAINTAINERS
--- a/MAINTAINERS~maintainers-add-missing-extcon-directory
+++ a/MAINTAINERS
@@ -4180,7 +4180,10 @@ L:	linux-kernel@vger.kernel.org
 T:	git git://git.kernel.org/pub/scm/linux/kernel/git/chanwoo/extcon.git
 S:	Maintained
 F:	drivers/extcon/
+F:	include/linux/extcon/
+F:	include/linux/extcon.h
 F:	Documentation/extcon/
+F:	Documentation/devicetree/bindings/extcon/
 
 EXYNOS DP DRIVER
 M:	Jingoo Han <jingoohan1@gmail.com>
_

Patches currently in -mm which might be from cw00.choi@samsung.com are

maintainers-add-missing-extcon-directory.patch

