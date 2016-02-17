From: akpm@linux-foundation.org
Subject: + maintainers-update-kselftest-framework-mailing-list.patch added to -mm tree
Date: Wed, 17 Feb 2016 10:56:41 -0800
Message-ID: <56c4c269.L6/Yxl7/PoqFb5l4%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:42013 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965208AbcBQS4m (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 17 Feb 2016 13:56:42 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: shuahkh@osg.samsung.com, mm-commits@vger.kernel.org


The patch titled
     Subject: MAINTAINERS: update Kselftest Framework mailing list
has been added to the -mm tree.  Its filename is
     maintainers-update-kselftest-framework-mailing-list.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/maintainers-update-kselftest-framework-mailing-list.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/maintainers-update-kselftest-framework-mailing-list.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Shuah Khan <shuahkh@osg.samsung.com>
Subject: MAINTAINERS: update Kselftest Framework mailing list

Kselftest Framework now has a dedicated mailing list linux-kselftest. 
Update the entry in MAINTAINERS file.

Signed-off-by: Shuah Khan <shuahkh@osg.samsung.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 MAINTAINERS |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN MAINTAINERS~maintainers-update-kselftest-framework-mailing-list MAINTAINERS
--- a/MAINTAINERS~maintainers-update-kselftest-framework-mailing-list
+++ a/MAINTAINERS
@@ -6128,7 +6128,7 @@ F:	include/uapi/linux/sunrpc/
 
 KERNEL SELFTEST FRAMEWORK
 M:	Shuah Khan <shuahkh@osg.samsung.com>
-L:	linux-api@vger.kernel.org
+L:	linux-kselftest@vger.kernel.org
 T:	git git://git.kernel.org/pub/scm/shuah/linux-kselftest
 S:	Maintained
 F:	tools/testing/selftests
_

Patches currently in -mm which might be from shuahkh@osg.samsung.com are

maintainers-update-kselftest-framework-mailing-list.patch

