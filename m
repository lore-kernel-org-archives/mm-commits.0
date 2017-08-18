From: akpm@linux-foundation.org
Subject: [patch 05/14] test_kmod: fix description for -s -and -c
 parameters
Date: Fri, 18 Aug 2017 15:16:02 -0700
Message-ID: <59976722.gvr5tpBnj9ya/8jB%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:46492 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752378AbdHRWQD (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 18 Aug 2017 18:16:03 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: torvalds@linux-foundation.org, mm-commits@vger.kernel.org, akpm@linux-foundation.org, mcgrof@kernel.org, colin.king@canonical.com, dan.carpenter@oracle.com, danielmentz@google.com, dcb314@hotmail.com, dmitry.torokhov@gmail.com, ebiederm@xmission.com, jeyu@redhat.com, jpoimboe@redhat.com, keescook@chromium.org, matt.redfearn@imgetc.com, matt.redfearn@imgtec.com, mbenes@suse.cz, mingo@redhat.com, mmarek@suse.com, peterz@infradead.org, pmladek@suse.com, rusty@rustcorp.com.au, shuah@kernel.org

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
