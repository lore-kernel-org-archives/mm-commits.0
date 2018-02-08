From: akpm@linux-foundation.org
Subject: + selftests-memfd-add-run_fuse_testsh-to-test_files.patch added
 to -mm tree
Date: Thu, 08 Feb 2018 12:36:03 -0800
Message-ID: <5a7cb4b3.64oFY5sjV0M46kP9%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 8bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:41208 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751848AbeBHUgE (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 8 Feb 2018 15:36:04 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: anders.roxell@linaro.org, daniel.diaz@linaro.org, shuah@kernel.org, mm-commits@vger.kernel.org


The patch titled
     Subject: selftests/memfd: add run_fuse_test.sh to TEST_FILES
has been added to the -mm tree.  Its filename is
     selftests-memfd-add-run_fuse_testsh-to-test_files.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/selftests-memfd-add-run_fuse_testsh-to-test_files.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/selftests-memfd-add-run_fuse_testsh-to-test_files.patch

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
Subject: selftests/memfd: add run_fuse_test.sh to TEST_FILES

While testing memfd tests, there is a missing script, as reported by
kselftest:

./run_tests.sh: line 7: ./run_fuse_test.sh: No such file or directory

Link: http://lkml.kernel.org/r/1517955779-11386-1-git-send-email-daniel.diaz@linaro.org
Signed-off-by: Anders Roxell <anders.roxell@linaro.org>
Signed-off-by: Daniel Díaz <daniel.diaz@linaro.org>
Cc: Shuah Khan <shuah@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 tools/testing/selftests/memfd/Makefile |    1 +
 1 file changed, 1 insertion(+)

diff -puN tools/testing/selftests/memfd/Makefile~selftests-memfd-add-run_fuse_testsh-to-test_files tools/testing/selftests/memfd/Makefile
--- a/tools/testing/selftests/memfd/Makefile~selftests-memfd-add-run_fuse_testsh-to-test_files
+++ a/tools/testing/selftests/memfd/Makefile
@@ -5,6 +5,7 @@ CFLAGS += -I../../../../include/
 CFLAGS += -I../../../../usr/include/
 
 TEST_PROGS := run_tests.sh
+TEST_FILES := run_fuse_test.sh
 TEST_GEN_FILES := memfd_test fuse_mnt fuse_test
 
 fuse_mnt.o: CFLAGS += $(shell pkg-config fuse --cflags)
_

Patches currently in -mm which might be from anders.roxell@linaro.org are

selftests-memfd-add-run_fuse_testsh-to-test_files.patch

