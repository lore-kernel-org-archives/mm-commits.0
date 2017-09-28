From: akpm@linux-foundation.org
Subject: + params-improve-standard_param_def-readability.patch added to
 -mm tree
Date: Thu, 28 Sep 2017 13:46:53 -0700
Message-ID: <59cd5fbd.c2z4QtIdN9eLFQPI%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:45860 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751567AbdI1Uqy (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 28 Sep 2017 16:46:54 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jdelvare@suse.de, bhe@redhat.com, mhocko@suse.com, mingo@kernel.org, mm-commits@vger.kernel.org


The patch titled
     Subject: kernel/params.c: improve STANDARD_PARAM_DEF readability
has been added to the -mm tree.  Its filename is
     params-improve-standard_param_def-readability.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/params-improve-standard_param_def-readability.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/params-improve-standard_param_def-readability.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Jean Delvare <jdelvare@suse.de>
Subject: kernel/params.c: improve STANDARD_PARAM_DEF readability

Align the parameters passed to STANDARD_PARAM_DEF for clarity.

Link: http://lkml.kernel.org/r/20170928162728.756143cc@endymion
Signed-off-by: Jean Delvare <jdelvare@suse.de>
Suggested-by: Ingo Molnar <mingo@kernel.org>
Acked-by: Ingo Molnar <mingo@kernel.org>
Cc: Baoquan He <bhe@redhat.com>
Cc: Michal Hocko <mhocko@suse.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/params.c |   16 ++++++++--------
 1 file changed, 8 insertions(+), 8 deletions(-)

diff -puN kernel/params.c~params-improve-standard_param_def-readability kernel/params.c
--- a/kernel/params.c~params-improve-standard_param_def-readability
+++ a/kernel/params.c
@@ -236,14 +236,14 @@ char *parse_args(const char *doing,
 	EXPORT_SYMBOL(param_ops_##name)
 
 
-STANDARD_PARAM_DEF(byte, unsigned char, "%hhu", kstrtou8);
-STANDARD_PARAM_DEF(short, short, "%hi", kstrtos16);
-STANDARD_PARAM_DEF(ushort, unsigned short, "%hu", kstrtou16);
-STANDARD_PARAM_DEF(int, int, "%i", kstrtoint);
-STANDARD_PARAM_DEF(uint, unsigned int, "%u", kstrtouint);
-STANDARD_PARAM_DEF(long, long, "%li", kstrtol);
-STANDARD_PARAM_DEF(ulong, unsigned long, "%lu", kstrtoul);
-STANDARD_PARAM_DEF(ullong, unsigned long long, "%llu", kstrtoull);
+STANDARD_PARAM_DEF(byte,	unsigned char,		"%hhu", kstrtou8);
+STANDARD_PARAM_DEF(short,	short,			"%hi",  kstrtos16);
+STANDARD_PARAM_DEF(ushort,	unsigned short,		"%hu",  kstrtou16);
+STANDARD_PARAM_DEF(int,		int,			"%i",   kstrtoint);
+STANDARD_PARAM_DEF(uint,	unsigned int,		"%u",   kstrtouint);
+STANDARD_PARAM_DEF(long,	long,			"%li",  kstrtol);
+STANDARD_PARAM_DEF(ulong,	unsigned long,		"%lu",  kstrtoul);
+STANDARD_PARAM_DEF(ullong,	unsigned long long,	"%llu", kstrtoull);
 
 int param_set_charp(const char *val, const struct kernel_param *kp)
 {
_

Patches currently in -mm which might be from jdelvare@suse.de are

params-align-add_sysfs_param-documentation-with-code.patch
params-fix-the-maximum-length-in-param_get_string.patch
params-fix-an-overflow-in-param_attr_show.patch
params-improve-standard_param_def-readability.patch

