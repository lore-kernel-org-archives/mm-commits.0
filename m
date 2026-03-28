Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A1B039443
	for <mm-commits@vger.kernel.org>; Sat, 28 Mar 2026 00:39:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774658355; cv=none; b=d0NoW3LM32KcfCMZ/mGbTUmOHixCCvWh2uNv1vJ5g0gg76zd+lkBWmlwAIEFdXhIQGsPIDPzA8oCtmv/4h6UJ9O6oR8CBL4OsVTgrnvrlw1xNfT2pVL9vRhAq1fCTJrlpoE7XH8xQCLbWrxBQeCMKB8p5BeWM6qde0AgDq7IE8A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774658355; c=relaxed/simple;
	bh=/94GD2QHVTQbIHeC+QZe5mjrwblM2GmsD7AGdXcxb1Q=;
	h=Date:To:From:Subject:Message-Id; b=V4Gif5bejJKV2DJ8Gaif9OpDWNB27dVbFI0+s/xa1POTKNk35DJC2/xUAiURXlqStLTaSYzo3jNqoK9g6gaKdqJGvYpge1SZNfm8Y8uMQG7ttPZ4htKkjhjL6rEZFbmnssKV1AE2jUIpimzDXlh/4/iOO/tDDujBsoqGUFp+5Ck=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=vasScQNa; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="vasScQNa"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3F84DC19423;
	Sat, 28 Mar 2026 00:39:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1774658355;
	bh=/94GD2QHVTQbIHeC+QZe5mjrwblM2GmsD7AGdXcxb1Q=;
	h=Date:To:From:Subject:From;
	b=vasScQNadjkwRHeueRH3+aclvwN9a2JTs4uqa5pAz2fcsz3qFqurdOZfjWUX+d9je
	 bl+M1KOYoFGBebyVWHm3ikuj0usjWmNbtmiq07C5s7C9XrUMEOr3T1Dfhm7KZENycF
	 K5KpwdCddYQuABV6AGi0AquTOXQvGRhYcTMhRlj8=
Date: Fri, 27 Mar 2026 17:39:14 -0700
To: mm-commits@vger.kernel.org,harry@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-hotfixes-stable] maintainers-mailmap-update-email-address-for-harry-yoo.patch removed from -mm tree
Message-Id: <20260328003915.3F84DC19423@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: MAINTAINERS, mailmap: update email address for Harry Yoo
has been removed from the -mm tree.  Its filename was
     maintainers-mailmap-update-email-address-for-harry-yoo.patch

This patch was dropped because it was merged into the mm-hotfixes-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: "Harry Yoo (Oracle)" <harry@kernel.org>
Subject: MAINTAINERS, mailmap: update email address for Harry Yoo
Date: Fri, 20 Mar 2026 21:59:25 +0900

Update my email address to harry@kernel.org.

Link: https://lkml.kernel.org/r/20260320125925.2259998-1-harry@kernel.org
Signed-off-by: Harry Yoo (Oracle) <harry@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 .mailmap    |    1 +
 MAINTAINERS |    4 ++--
 2 files changed, 3 insertions(+), 2 deletions(-)

--- a/.mailmap~maintainers-mailmap-update-email-address-for-harry-yoo
+++ a/.mailmap
@@ -316,6 +316,7 @@ Hans Verkuil <hverkuil@kernel.org> <hver
 Hans Verkuil <hverkuil@kernel.org> <hansverk@cisco.com>
 Hao Ge <hao.ge@linux.dev> <gehao@kylinos.cn>
 Harry Yoo <harry.yoo@oracle.com> <42.hyeyoo@gmail.com>
+Harry Yoo <harry@kernel.org> <harry.yoo@oracle.com>
 Heiko Carstens <hca@linux.ibm.com> <h.carstens@de.ibm.com>
 Heiko Carstens <hca@linux.ibm.com> <heiko.carstens@de.ibm.com>
 Heiko Stuebner <heiko@sntech.de> <heiko.stuebner@bqreaders.com>
--- a/MAINTAINERS~maintainers-mailmap-update-email-address-for-harry-yoo
+++ a/MAINTAINERS
@@ -16877,7 +16877,7 @@ M:	Lorenzo Stoakes <ljs@kernel.org>
 R:	Rik van Riel <riel@surriel.com>
 R:	Liam R. Howlett <Liam.Howlett@oracle.com>
 R:	Vlastimil Babka <vbabka@kernel.org>
-R:	Harry Yoo <harry.yoo@oracle.com>
+R:	Harry Yoo <harry@kernel.org>
 R:	Jann Horn <jannh@google.com>
 L:	linux-mm@kvack.org
 S:	Maintained
@@ -24343,7 +24343,7 @@ F:	drivers/nvmem/layouts/sl28vpd.c
 
 SLAB ALLOCATOR
 M:	Vlastimil Babka <vbabka@kernel.org>
-M:	Harry Yoo <harry.yoo@oracle.com>
+M:	Harry Yoo <harry@kernel.org>
 M:	Andrew Morton <akpm@linux-foundation.org>
 R:	Hao Li <hao.li@linux.dev>
 R:	Christoph Lameter <cl@gentwo.org>
_

Patches currently in -mm which might be from harry@kernel.org are


