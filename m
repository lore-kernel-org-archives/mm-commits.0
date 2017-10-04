From: akpm@linux-foundation.org
Subject: [merged]
 params-improve-standard_param_def-readability.patch removed from -mm tree
Date: Wed, 04 Oct 2017 12:42:10 -0700
Message-ID: <20171004194210.sR62L7UFn%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:33780 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751132AbdJDTmL (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 4 Oct 2017 15:42:11 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: bhe@redhat.com, jdelvare@suse.de, mhocko@suse.com, mingo@kernel.org, mm-commits@vger.kernel.org


The patch titled
     Subject: kernel/params.c: improve STANDARD_PARAM_DEF readability
has been removed from the -mm tree.  Its filename was
     params-improve-standard_param_def-readability.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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


