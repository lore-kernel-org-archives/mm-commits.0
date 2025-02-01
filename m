Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A0966153565
	for <mm-commits@vger.kernel.org>; Sat,  1 Feb 2025 11:54:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738410846; cv=none; b=sismxqgi4N1VXgmsreTYc9sH095QA3186g6cJyq8QoVbhG1sMab/yZp178lD6z3s2etEql4kXabQ3kqjNdKCbeixmvGyTYGSSNtMO0cKLofsk+4hr+EL6devuvj0x0OIb+mvxRzRLpB22LYLdiMsk9UbdWkgYp5Jg8UEqNhqX5M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738410846; c=relaxed/simple;
	bh=d/MCoq/NQTkwJsc1OypPZVZQHZYMvOsvhJXRRyDPmjU=;
	h=Date:To:From:Subject:Message-Id; b=amXV505o8TbVmqTAk1lfSqLpqKnyHu7ZeVYBJethRRCrKXoBRHUWQo/5QC21QNsFEMyN35px9dQJBdhWe8ZBNxY041HLsLgScNOWR7DxbV1ylV69e++yOunxrOc4iMl/pRVY5DwfJEJh9TwnHd+2WJfsbExtpjRFvPgKzlqHyt0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=cH4etemJ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="cH4etemJ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 11F47C4CED3;
	Sat,  1 Feb 2025 11:54:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1738410846;
	bh=d/MCoq/NQTkwJsc1OypPZVZQHZYMvOsvhJXRRyDPmjU=;
	h=Date:To:From:Subject:From;
	b=cH4etemJuKRkP9lf5YxDvIjvPIS5XPk902i5MJK0FHvH++yhYCFBldSJTdkuXxk08
	 QzkOasuDuni2IherDuR/bYva7Lh3TgBea3WRlIZZBkyerHIhX0KDw+piIOCFT4AVKB
	 gczWhqowCVa3mCvQsJ/HsMpYn6npis6VPexAUIPA=
Date: Sat, 01 Feb 2025 03:54:05 -0800
To: mm-commits@vger.kernel.org,matttbe@kernel.org,hverkuil@xs4all.nl,davem@davemloft.net,hamzamahfooz@linux.microsoft.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-hotfixes-stable] mailmap-add-an-entry-for-hamza-mahfooz.patch removed from -mm tree
Message-Id: <20250201115406.11F47C4CED3@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mailmap: add an entry for Hamza Mahfooz
has been removed from the -mm tree.  Its filename was
     mailmap-add-an-entry-for-hamza-mahfooz.patch

This patch was dropped because it was merged into the mm-hotfixes-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Hamza Mahfooz <hamzamahfooz@linux.microsoft.com>
Subject: mailmap: add an entry for Hamza Mahfooz
Date: Mon, 20 Jan 2025 15:56:59 -0500

Map my previous work email to my current one.

Link: https://lkml.kernel.org/r/20250120205659.139027-1-hamzamahfooz@linux.microsoft.com
Signed-off-by: Hamza Mahfooz <hamzamahfooz@linux.microsoft.com>
Cc: David S. Miller <davem@davemloft.net>
Cc: Hans verkuil <hverkuil@xs4all.nl>
Cc: Matthieu Baerts <matttbe@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 .mailmap |    1 +
 1 file changed, 1 insertion(+)

--- a/.mailmap~mailmap-add-an-entry-for-hamza-mahfooz
+++ a/.mailmap
@@ -261,6 +261,7 @@ Guo Ren <guoren@kernel.org> <ren_guo@c-s
 Guru Das Srinagesh <quic_gurus@quicinc.com> <gurus@codeaurora.org>
 Gustavo Padovan <gustavo@las.ic.unicamp.br>
 Gustavo Padovan <padovan@profusion.mobi>
+Hamza Mahfooz <hamzamahfooz@linux.microsoft.com> <hamza.mahfooz@amd.com>
 Hanjun Guo <guohanjun@huawei.com> <hanjun.guo@linaro.org>
 Hans Verkuil <hverkuil@xs4all.nl> <hansverk@cisco.com>
 Hans Verkuil <hverkuil@xs4all.nl> <hverkuil-cisco@xs4all.nl>
_

Patches currently in -mm which might be from hamzamahfooz@linux.microsoft.com are


