From: akpm@linux-foundation.org
Subject: + test_kmod-fix-description-for-s-and-c-parameters.patch added to -mm tree
Date: Thu, 10 Aug 2017 14:19:22 -0700
Message-ID: <598ccdda.t38SGlsbLlWhcH9E%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:42698 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752983AbdHJVTY (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 10 Aug 2017 17:19:24 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mcgrof@kernel.org, colin.king@canonical.com, dan.carpenter@oracle.com, danielmentz@google.com, dcb314@hotmail.com, dmitry.torokhov@gmail.com, ebiederm@xmission.com, jeyu@redhat.com, jpoimboe@redhat.com, keescook@chromium.org, matt.redfearn@imgetc.com, matt.redfearn@imgtec.com, mbenes@suse.cz, mingo@redhat.com, mmarek@suse.com, peterz@infradead.org, pmladek@suse.com, rusty@rustcorp.com.au, shuah@kernel.org, mm-commits@vger.kernel.org


The patch titled
     Subject: test_kmod: fix description for -s -and -c parameters
has been added to the -mm tree.  Its filename is
     test_kmod-fix-description-for-s-and-c-parameters.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/test_kmod-fix-description-for-s-and-c-parameters.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/test_kmod-fix-description-for-s-and-c-parameters.patch

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
Subject: test_kmod: fix description for -s -and -c parameters

The descriptions were reversed, correct this.

Link: http://lkml.kernel.org/r/20170809234635.13443-4-mcgrof@kernel.org
Fixes: 64b671204afd71 ("test_sysctl: add generic script to expand on tests")
Signed-off-by: Luis R. Rodriguez <mcgrof@kernel.org>
Reported-by: Daniel Mentz <danielmentz@google.com>
Cc: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: Colin Ian King <colin.king@canonical.com>
Cc: Dan Carpenter <dan.carpenter@oracle.com>
Cc: David Binderman <dcb314@hotmail.com>
Cc: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Jessica Yu <jeyu@redhat.com>
Cc: Josh Poimboeuf <jpoimboe@redhat.com>
Cc: Kees Cook <keescook@chromium.org>
Cc: Matt Redfearn <matt.redfearn@imgetc.com>
Cc: Matt Redfearn <matt.redfearn@imgtec.com>
Cc: Michal Marek <mmarek@suse.com>
Cc: Miroslav Benes <mbenes@suse.cz>
Cc: Peter Zijlstra (Intel) <peterz@infradead.org>
Cc: Petr Mladek <pmladek@suse.com>
Cc: Rusty Russell <rusty@rustcorp.com.au>
Cc: Shuah Khan <shuah@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 tools/testing/selftests/kmod/kmod.sh |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff -puN tools/testing/selftests/kmod/kmod.sh~test_kmod-fix-description-for-s-and-c-parameters tools/testing/selftests/kmod/kmod.sh
--- a/tools/testing/selftests/kmod/kmod.sh~test_kmod-fix-description-for-s-and-c-parameters
+++ a/tools/testing/selftests/kmod/kmod.sh
@@ -473,8 +473,8 @@ usage()
 	echo "    all     Runs all tests (default)"
 	echo "    -t      Run test ID the number amount of times is recommended"
 	echo "    -w      Watch test ID run until it runs into an error"
-	echo "    -c      Run test ID once"
-	echo "    -s      Run test ID x test-count number of times"
+	echo "    -s      Run test ID once"
+	echo "    -c      Run test ID x test-count number of times"
 	echo "    -l      List all test ID list"
 	echo " -h|--help  Help"
 	echo
_

Patches currently in -mm which might be from mcgrof@kernel.org are

test_kmod-fix-bug-which-allows-negative-values-on-two-config-options.patch
wait-add-wait_event_killable_timeout.patch
kmod-fix-wait-on-recursive-loop.patch
test_kmod-fix-description-for-s-and-c-parameters.patch
kmod-split-out-umh-code-into-its-own-file.patch
maintainers-clarify-kmod-is-just-a-kernel-module-loader.patch
kmod-split-off-umh-headers-into-its-own-file.patch
kmod-move-ifdef-config_modules-wrapper-to-makefile.patch

