From: akpm@linux-foundation.org
Subject: [merged] maintainers-add-missing-extcon-directory.patch removed
 from -mm tree
Date: Mon, 09 Nov 2015 11:46:14 -0800
Message-ID: <5640f806.xFGQoogZ75yWA8JZ%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:57343 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751697AbbKITqO (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 9 Nov 2015 14:46:14 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: cw00.choi@samsung.com, mm-commits@vger.kernel.org


The patch titled
     Subject: MAINTAINERS: add missing extcon directory
has been removed from the -mm tree.  Its filename was
     maintainers-add-missing-extcon-directory.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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
@@ -4207,7 +4207,10 @@ L:	linux-kernel@vger.kernel.org
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


