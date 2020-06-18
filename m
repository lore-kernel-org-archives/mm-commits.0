From: akpm@linux-foundation.org
Subject: +
 lib-kconfigdebug-fix-typo-in-the-help-text-of-config_panic_timeout.patch
 added to -mm tree
Date: Wed, 17 Jun 2020 18:52:38 -0700
Message-ID: <20200618015238.ZMPJS%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:42778 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730642AbgFRBwj (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Wed, 17 Jun 2020 21:52:39 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, lixuefeng@loongson.cn, keescook@chromium.org, yangtiezhu@loongson.cn


The patch titled
     Subject: lib/Kconfig.debug: fix typo in the help text of CONFIG_PANIC_TIMEOUT
has been added to the -mm tree.  Its filename is
     lib-kconfigdebug-fix-typo-in-the-help-text-of-config_panic_timeout.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/lib-kconfigdebug-fix-typo-in-the-help-text-of-config_panic_timeout.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/lib-kconfigdebug-fix-typo-in-the-help-text-of-config_panic_timeout.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Tiezhu Yang <yangtiezhu@loongson.cn>
Subject: lib/Kconfig.debug: fix typo in the help text of CONFIG_PANIC_TIMEOUT

There exists duplicated "the" in the help text of CONFIG_PANIC_TIMEOUT,
Remove it.

Link: http://lkml.kernel.org/r/1591103358-32087-2-git-send-email-yangtiezhu@loongson.cn
Signed-off-by: Tiezhu Yang <yangtiezhu@loongson.cn>
Reviewed-by: Kees Cook <keescook@chromium.org>
Cc: Xuefeng Li <lixuefeng@loongson.cn>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/Kconfig.debug |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/lib/Kconfig.debug~lib-kconfigdebug-fix-typo-in-the-help-text-of-config_panic_timeout
+++ a/lib/Kconfig.debug
@@ -875,7 +875,7 @@ config PANIC_TIMEOUT
 	int "panic timeout"
 	default 0
 	help
-	  Set the timeout value (in seconds) until a reboot occurs when the
+	  Set the timeout value (in seconds) until a reboot occurs when
 	  the kernel panics. If n = 0, then we wait forever. A timeout
 	  value n > 0 will wait n seconds before rebooting, while a timeout
 	  value n < 0 will reboot immediately.
_

Patches currently in -mm which might be from yangtiezhu@loongson.cn are

selftests-kmod-use-variable-name-in-kmod_test_0001.patch
kmod-remove-redundant-be-an-in-the-comment.patch
test_kmod-avoid-potential-double-free-in-trigger_config_run_type.patch
kernel-panicc-make-oops_may_print-return-bool.patch
lib-kconfigdebug-fix-typo-in-the-help-text-of-config_panic_timeout.patch
