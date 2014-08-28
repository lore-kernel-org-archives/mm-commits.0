From: akpm@linux-foundation.org
Subject: + maintainers-add-entry-for-kernel-selftest-framework.patch added to -mm tree
Date: Thu, 28 Aug 2014 14:49:53 -0700
Message-ID: <53ffa401.69uQWcid6w/1ZRyR%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-oi0-f73.google.com ([209.85.218.73]:54494 "EHLO
	mail-oi0-f73.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751506AbaH1WFd (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 28 Aug 2014 18:05:33 -0400
Received: by mail-oi0-f73.google.com with SMTP id u20so409946oif.4
        for <mm-commits@vger.kernel.org>; Thu, 28 Aug 2014 15:05:33 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: shuahkh@osg.samsung.com, mm-commits@vger.kernel.org


The patch titled
     Subject: MAINTAINERS: add entry for Kernel Selftest Framework
has been added to the -mm tree.  Its filename is
     maintainers-add-entry-for-kernel-selftest-framework.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/maintainers-add-entry-for-kernel-selftest-framework.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/maintainers-add-entry-for-kernel-selftest-framework.patch

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
Subject: MAINTAINERS: add entry for Kernel Selftest Framework

Add entry for Kernel Selftest Framework.  Individual tests continue to be
maintained by the maintainers for those areas.

Signed-off-by: Shuah Khan <shuahkh@osg.samsung.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 MAINTAINERS |    7 +++++++
 1 file changed, 7 insertions(+)

diff -puN MAINTAINERS~maintainers-add-entry-for-kernel-selftest-framework MAINTAINERS
--- a/MAINTAINERS~maintainers-add-entry-for-kernel-selftest-framework
+++ a/MAINTAINERS
@@ -5207,6 +5207,13 @@ F:	include/linux/lockd/
 F:	include/linux/sunrpc/
 F:	include/uapi/linux/sunrpc/
 
+KERNEL SELFTEST FRAMEWORK
+M:	Shuah Khan <shuahkh@osg.samsung.com>
+L:	linux-api@vger.kernel.org
+T:	git git://git.kernel.org/pub/scm/shuah/linux-kselftest
+S:	Maintained
+F:	tools/testing/selftests
+
 KERNEL VIRTUAL MACHINE (KVM)
 M:	Gleb Natapov <gleb@kernel.org>
 M:	Paolo Bonzini <pbonzini@redhat.com>
_

Patches currently in -mm which might be from shuahkh@osg.samsung.com are

maintainers-add-entry-for-kernel-selftest-framework.patch

