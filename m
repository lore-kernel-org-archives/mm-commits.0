From: akpm@linux-foundation.org
Subject: + test_kmod-fix-spelling-mistake-emtpy-empty.patch added to -mm
 tree
Date: Wed, 02 Aug 2017 15:46:57 -0700
Message-ID: <59825661.cjzvclHoKImJA6vd%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:54096 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751058AbdHBWq6 (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 2 Aug 2017 18:46:58 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: colin.king@canonical.com, dan.carpenter@oracle.com, dcb314@hotmail.com, dmitry.torokhov@gmail.com, ebiederm@xmission.com, jeyu@redhat.com, jpoimboe@redhat.com, keescook@chromium.org, mbenes@suse.cz, mcgrof@kernel.org, mmarek@suse.com, pmladek@suse.com, rusty@rustcorp.com.au, shuah@kernel.org, mm-commits@vger.kernel.org


The patch titled
     Subject: test_kmod: fix spelling mistake: "EMTPY" -> "EMPTY"
has been added to the -mm tree.  Its filename is
     test_kmod-fix-spelling-mistake-emtpy-empty.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/test_kmod-fix-spelling-mistake-emtpy-empty.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/test_kmod-fix-spelling-mistake-emtpy-empty.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Colin Ian King <colin.king@canonical.com>
Subject: test_kmod: fix spelling mistake: "EMTPY" -> "EMPTY"

Trivial fix to spelling mistake in snprintf text

[mcgrof@kernel.org: massaged commit message]
Link: http://lkml.kernel.org/r/20170802211450.27928-3-mcgrof@kernel.org
Fixes: 39258f448d71 ("kmod: add test driver to stress test the module loader")
Signed-off-by: Colin Ian King <colin.king@canonical.com>
Signed-off-by: Luis R. Rodriguez <mcgrof@kernel.org>
Cc: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Cc: Kees Cook <keescook@chromium.org>
Cc: Jessica Yu <jeyu@redhat.com>
Cc: Rusty Russell <rusty@rustcorp.com.au>
Cc: Michal Marek <mmarek@suse.com>
Cc: Petr Mladek <pmladek@suse.com>
Cc: Miroslav Benes <mbenes@suse.cz>
Cc: Josh Poimboeuf <jpoimboe@redhat.com>
Cc: Eric W. Biederman <ebiederm@xmission.com>
Cc: Shuah Khan <shuah@kernel.org>
Cc: Dan Carpenter <dan.carpenter@oracle.com>
Cc: David Binderman <dcb314@hotmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/test_kmod.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff -puN lib/test_kmod.c~test_kmod-fix-spelling-mistake-emtpy-empty lib/test_kmod.c
--- a/lib/test_kmod.c~test_kmod-fix-spelling-mistake-emtpy-empty
+++ a/lib/test_kmod.c
@@ -485,7 +485,7 @@ static ssize_t config_show(struct device
 				config->test_driver);
 	else
 		len += snprintf(buf+len, PAGE_SIZE - len,
-				"driver:\tEMTPY\n");
+				"driver:\tEMPTY\n");
 
 	if (config->test_fs)
 		len += snprintf(buf+len, PAGE_SIZE - len,
@@ -493,7 +493,7 @@ static ssize_t config_show(struct device
 				config->test_fs);
 	else
 		len += snprintf(buf+len, PAGE_SIZE - len,
-				"fs:\tEMTPY\n");
+				"fs:\tEMPTY\n");
 
 	mutex_unlock(&test_dev->config_mutex);
 
_

Patches currently in -mm which might be from colin.king@canonical.com are

test_kmod-fix-spelling-mistake-emtpy-empty.patch

