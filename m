From: akpm@linux-foundation.org
Subject: + maintainers-add-git-url-for-devfreq.patch added to -mm tree
Date: Fri, 18 Dec 2015 15:33:22 -0800
Message-ID: <567497c2.v9zpnDzwKs3AnWaD%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:46397 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752036AbbLRXdX (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 18 Dec 2015 18:33:23 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: xiaolong.ye@intel.com, fengguang.wu@intel.com, kyungmin.park@samsung.com, myungjoo.ham@samsung.com, mm-commits@vger.kernel.org


The patch titled
     Subject: MAINTAINERS: add git URL for devfreq
has been added to the -mm tree.  Its filename is
     maintainers-add-git-url-for-devfreq.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/maintainers-add-git-url-for-devfreq.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/maintainers-add-git-url-for-devfreq.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Xiaolong Ye <xiaolong.ye@intel.com>
Subject: MAINTAINERS: add git URL for devfreq

Signed-off-by: Xiaolong Ye <xiaolong.ye@intel.com>
Signed-off-by: Fengguang Wu <fengguang.wu@intel.com>
Cc: MyungJoo Ham <myungjoo.ham@samsung.com>
Cc: Kyungmin Park <kyungmin.park@samsung.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 MAINTAINERS |    1 +
 1 file changed, 1 insertion(+)

diff -puN MAINTAINERS~maintainers-add-git-url-for-devfreq MAINTAINERS
--- a/MAINTAINERS~maintainers-add-git-url-for-devfreq
+++ a/MAINTAINERS
@@ -3436,6 +3436,7 @@ DEVICE FREQUENCY (DEVFREQ)
 M:	MyungJoo Ham <myungjoo.ham@samsung.com>
 M:	Kyungmin Park <kyungmin.park@samsung.com>
 L:	linux-pm@vger.kernel.org
+T:	git git://git.kernel.org/pub/scm/linux/kernel/git/mzx/devfreq.git
 S:	Maintained
 F:	drivers/devfreq/
 
_

Patches currently in -mm which might be from xiaolong.ye@intel.com are

maintainers-add-git-url-for-devfreq.patch

