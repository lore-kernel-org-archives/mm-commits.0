Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 45AC4331220
	for <mm-commits@vger.kernel.org>; Sat, 28 Mar 2026 04:24:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774671887; cv=none; b=JMEzxVJumSAEUReVqpV1j+blk5hViAexNHIX9bzNmqmZEjmtBJ0AtUNsRIMmod65QDKIOLBRzE47oMBL6DzU7pyYHnYG7HJJG2y1r9k38lJjhMqWy5GTcupzgXzpcWW3mI8HTbDnZvmnjOiHuwmoqg+2yEnpTBxZuwEPqzbBHuo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774671887; c=relaxed/simple;
	bh=TXw0Tliip+KQWmhKyBmdR46EpvQgGZ3HIQWYJmWW9cA=;
	h=Date:To:From:Subject:Message-Id; b=Oq6QD9ECjP/bLE1zuWgU66ETeCDj9+qxEl9At/SCVf/pnfG8n3P/q2DPsbh7MzU1eHjYlTrUDa2f3yxmYYm+8j5FA2wfZA0o+JbKW534JRjNE8Yn1iNrgTZlcvdEOhO0siuM76XGg/ETZ6eKGv01jtbWzK77bCMixoXWoneEav8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=LVwZZChW; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="LVwZZChW"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D0E14C4CEF7;
	Sat, 28 Mar 2026 04:24:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1774671886;
	bh=TXw0Tliip+KQWmhKyBmdR46EpvQgGZ3HIQWYJmWW9cA=;
	h=Date:To:From:Subject:From;
	b=LVwZZChW/dxfbEY0JBY4bxz8NILT8CAlJx3cOvtMQyRoXupeBnItrAEtX/Uv7baoG
	 sco8ry5RnxzM7j/8bBYv0B5Hi+k7H16Wfto5LyP2dp/BCNp2nuyeIwLI119nQZAyau
	 JoA3p/rWaBtzp4NCzC34Wd1SaxRb+3VJwY6M+mRY=
Date: Fri, 27 Mar 2026 21:24:46 -0700
To: mm-commits@vger.kernel.org,wangyuli@uniontech.com,Jonathan.Cameron@huawei.com,pvorel@suse.cz,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-nonmm-stable] scripts-spellingtxt-add-exaclty-typo.patch removed from -mm tree
Message-Id: <20260328042446.D0E14C4CEF7@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: scripts/spelling.txt: add "exaclty" typo
has been removed from the -mm tree.  Its filename was
     scripts-spellingtxt-add-exaclty-typo.patch

This patch was dropped because it was merged into the mm-nonmm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Petr Vorel <pvorel@suse.cz>
Subject: scripts/spelling.txt: add "exaclty" typo
Date: Thu, 12 Feb 2026 15:40:05 +0100

Link: https://lkml.kernel.org/r/20260212144005.45052-2-pvorel@suse.cz
Signed-off-by: Petr Vorel <pvorel@suse.cz>
Cc: Jonathan Camerom <Jonathan.Cameron@huawei.com>
Cc: WangYuli <wangyuli@uniontech.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 scripts/spelling.txt |    1 +
 1 file changed, 1 insertion(+)

--- a/scripts/spelling.txt~scripts-spellingtxt-add-exaclty-typo
+++ a/scripts/spelling.txt
@@ -654,6 +654,7 @@ evalute||evaluate
 evalutes||evaluates
 evalution||evaluation
 evaulated||evaluated
+exaclty||exactly
 excceed||exceed
 excecutable||executable
 exceded||exceeded
_

Patches currently in -mm which might be from pvorel@suse.cz are


