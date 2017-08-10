From: akpm@linux-foundation.org
Subject: + maintainers-clarify-kmod-is-just-a-kernel-module-loader.patch
 added to -mm tree
Date: Thu, 10 Aug 2017 13:44:25 -0700
Message-ID: <598cc5a9.YGzdWDKzx+cgKJ6C%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:37576 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753223AbdHJUo1 (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 10 Aug 2017 16:44:27 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mcgrof@kernel.org, colin.king@canonical.com, dan.carpenter@oracle.com, danielmentz@google.com, dcb314@hotmail.com, dmitry.torokhov@gmail.com, ebiederm@xmission.com, gregkh@linuxfoundation.org, jeyu@redhat.com, jpoimboe@redhat.com, keescook@chromium.org, linux@roeck-us.net, matt.redfearn@imgtec.com, mbenes@suse.cz, mmarek@suse.com, pmladek@suse.com, rusty@rustcorp.com.au, mm-commits@vger.kernel.org


The patch titled
     Subject: MAINTAINERS: clarify kmod is just a kernel module loader
has been added to the -mm tree.  Its filename is
     maintainers-clarify-kmod-is-just-a-kernel-module-loader.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/maintainers-clarify-kmod-is-just-a-kernel-module-loader.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/maintainers-clarify-kmod-is-just-a-kernel-module-loader.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: "Luis R. Rodriguez" <mcgrof@kernel.org>
Subject: MAINTAINERS: clarify kmod is just a kernel module loader

This should make it clearer what the kmod code is now that
the umh code is split out separately.

Link: http://lkml.kernel.org/r/20170810180618.22457-3-mcgrof@kernel.org
Signed-off-by: Luis R. Rodriguez <mcgrof@kernel.org>
Cc: Kees Cook <keescook@chromium.org>
Cc: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Cc: Jessica Yu <jeyu@redhat.com>
Cc: Rusty Russell <rusty@rustcorp.com.au>
Cc: Michal Marek <mmarek@suse.com>
Cc: Petr Mladek <pmladek@suse.com>
Cc: Miroslav Benes <mbenes@suse.cz>
Cc: Josh Poimboeuf <jpoimboe@redhat.com>
Cc: Guenter Roeck <linux@roeck-us.net>
Cc: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: Matt Redfearn <matt.redfearn@imgtec.com>
Cc: Dan Carpenter <dan.carpenter@oracle.com>
Cc: Colin Ian King <colin.king@canonical.com>
Cc: Daniel Mentz <danielmentz@google.com>
Cc: David Binderman <dcb314@hotmail.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 MAINTAINERS |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN MAINTAINERS~maintainers-clarify-kmod-is-just-a-kernel-module-loader MAINTAINERS
--- a/MAINTAINERS~maintainers-clarify-kmod-is-just-a-kernel-module-loader
+++ a/MAINTAINERS
@@ -7546,7 +7546,7 @@ F:	include/linux/kmemleak.h
 F:	mm/kmemleak.c
 F:	mm/kmemleak-test.c
 
-KMOD MODULE USERMODE HELPER
+KMOD KERNEL MODULE LOADER - USERMODE HELPER
 M:	"Luis R. Rodriguez" <mcgrof@kernel.org>
 L:	linux-kernel@vger.kernel.org
 S:	Maintained
_

Patches currently in -mm which might be from mcgrof@kernel.org are

test_kmod-fix-bug-which-allows-negative-values-on-two-config-options.patch
kmod-split-out-umh-code-into-its-own-file.patch
maintainers-clarify-kmod-is-just-a-kernel-module-loader.patch
kmod-split-off-umh-headers-into-its-own-file.patch
kmod-move-ifdef-config_modules-wrapper-to-makefile.patch

