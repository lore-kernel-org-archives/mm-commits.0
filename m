From: akpm@linux-foundation.org
Subject: + cpumask-remove-incorrect-information-from-comment.patch added
 to -mm tree
Date: Tue, 23 Feb 2016 16:27:04 -0800
Message-ID: <56ccf8d8.++OqOiAN/UhgKRuh%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:37731 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753232AbcBXA1E (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 23 Feb 2016 19:27:04 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: ebiggers3@gmail.com, rusty@rustcorp.com.au, mm-commits@vger.kernel.org


The patch titled
     Subject: cpumask: remove incorrect information from comment
has been added to the -mm tree.  Its filename is
     cpumask-remove-incorrect-information-from-comment.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/cpumask-remove-incorrect-information-from-comment.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/cpumask-remove-incorrect-information-from-comment.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Eric Biggers <ebiggers3@gmail.com>
Subject: cpumask: remove incorrect information from comment

Since commit cdfdef75e795f ("cpumask: only allocate nr_cpumask_bits."),
this comment above cpumask_size() is no longer relevant.

Signed-off-by: Eric Biggers <ebiggers3@gmail.com>
Cc: Rusty Russell <rusty@rustcorp.com.au>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/cpumask.h |    2 --
 1 file changed, 2 deletions(-)

diff -puN include/linux/cpumask.h~cpumask-remove-incorrect-information-from-comment include/linux/cpumask.h
--- a/include/linux/cpumask.h~cpumask-remove-incorrect-information-from-comment
+++ a/include/linux/cpumask.h
@@ -607,8 +607,6 @@ static inline int cpulist_parse(const ch
 
 /**
  * cpumask_size - size to allocate for a 'struct cpumask' in bytes
- *
- * This will eventually be a runtime variable, depending on nr_cpu_ids.
  */
 static inline size_t cpumask_size(void)
 {
_

Patches currently in -mm which might be from ebiggers3@gmail.com are

cpumask-remove-incorrect-information-from-comment.patch

