Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B1A4E13FF1
	for <mm-commits@vger.kernel.org>; Fri, 29 Dec 2023 20:23:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="b8+RC5KZ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7DA6EC433C8;
	Fri, 29 Dec 2023 20:23:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1703881398;
	bh=e6gFc3IwsplkfzACh6FDJS4jKLnooThKiqWOen9Q0t0=;
	h=Date:To:From:Subject:From;
	b=b8+RC5KZhKxqQl4tQNMy4YFQQ3GGM0irWNRrDOjBQw4bNZQR3O29BWTCNu9Jfx+zk
	 qFhIVLIMDTrvOMyCugcPf6lYPGtQ9Hrz0bsqfQtksLxM/h1J0Hm8gF/5ViJtmAnqZQ
	 +LLQr7549VJmoEbfe3jwOXpk+8EJi4AVMhZxoGOQ=
Date: Fri, 29 Dec 2023 12:23:18 -0800
To: mm-commits@vger.kernel.org,corbet@lwn.net,yangtiezhu@loongson.cn,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-nonmm-stable] scripts-checkstackpl-add-min_stack-to-the-usage-comment.patch removed from -mm tree
Message-Id: <20231229202318.7DA6EC433C8@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: scripts/checkstack.pl: add min_stack to the usage comment
has been removed from the -mm tree.  Its filename was
     scripts-checkstackpl-add-min_stack-to-the-usage-comment.patch

This patch was dropped because it was merged into the mm-nonmm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Tiezhu Yang <yangtiezhu@loongson.cn>
Subject: scripts/checkstack.pl: add min_stack to the usage comment
Date: Tue, 19 Dec 2023 20:49:58 +0800

After commit 572220aad525 ("scripts/checkstack.pl: Add argument to print
stacks greather than value."), it is appropriate to add min_stack to the
usage comment, then the users know explicitly that "min_stack" can be
specified like "arch".

Link: https://lkml.kernel.org/r/20231219125008.23007-3-yangtiezhu@loongson.cn
Signed-off-by: Tiezhu Yang <yangtiezhu@loongson.cn>
Cc: Jonathan Corbet <corbet@lwn.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 scripts/checkstack.pl |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/scripts/checkstack.pl~scripts-checkstackpl-add-min_stack-to-the-usage-comment
+++ a/scripts/checkstack.pl
@@ -18,7 +18,7 @@
 #	loongarch port by Youling Tang <tangyouling@kylinos.cn>
 #
 #	Usage:
-#	objdump -d vmlinux | scripts/checkstack.pl [arch]
+#	objdump -d vmlinux | scripts/checkstack.pl [arch] [min_stack]
 #
 #	TODO :	Port to all architectures (one regex per arch)
 
_

Patches currently in -mm which might be from yangtiezhu@loongson.cn are


