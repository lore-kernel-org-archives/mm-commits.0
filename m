From: akpm@linux-foundation.org
Subject: + lib-kconfigdebug-enable-runtime_testing_menu.patch added to -mm tree
Date: Wed, 14 Feb 2018 16:26:03 -0800
Message-ID: <5a84d39b.XjF10D5WGbseYlad%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:47100 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1032190AbeBOA0E (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 14 Feb 2018 19:26:04 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: anders.roxell@linaro.org, byungchul.park@lge.com, mingo@kernel.org, vincent.legoll@gmail.com, mm-commits@vger.kernel.org


The patch titled
     Subject: lib/Kconfig.debug: enable RUNTIME_TESTING_MENU
has been added to the -mm tree.  Its filename is
     lib-kconfigdebug-enable-runtime_testing_menu.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/lib-kconfigdebug-enable-runtime_testing_menu.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/lib-kconfigdebug-enable-runtime_testing_menu.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Anders Roxell <anders.roxell@linaro.org>
Subject: lib/Kconfig.debug: enable RUNTIME_TESTING_MENU

d3deafaa8b5c ("lib/: make RUNTIME_TESTS a menuconfig to ease disabling it
all") causes a regression when using runtime tests due to it defaults
RUNTIME_TESTING_MENU to not set.

Link: http://lkml.kernel.org/r/20180214133015.10090-1-anders.roxell@linaro.org
Fixes: d3deafaa8b5c ("lib/: make RUNTIME_TESTS a menuconfig to easedisabling it all")
Signed-off-by: Anders Roxell <anders.roxell@linaro.org>
Cc: Vincent Legoll <vincent.legoll@gmail.com>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Byungchul Park <byungchul.park@lge.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/Kconfig.debug |    1 +
 1 file changed, 1 insertion(+)

diff -puN lib/Kconfig.debug~lib-kconfigdebug-enable-runtime_testing_menu lib/Kconfig.debug
--- a/lib/Kconfig.debug~lib-kconfigdebug-enable-runtime_testing_menu
+++ a/lib/Kconfig.debug
@@ -1642,6 +1642,7 @@ config DMA_API_DEBUG
 
 menuconfig RUNTIME_TESTING_MENU
 	bool "Runtime Testing"
+	def_bool y
 
 if RUNTIME_TESTING_MENU
 
_

Patches currently in -mm which might be from anders.roxell@linaro.org are

selftests-memfd-add-run_fuse_testsh-to-test_files.patch
lib-kconfigdebug-enable-runtime_testing_menu.patch

