Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5C2191366
	for <mm-commits@vger.kernel.org>; Mon,  6 May 2024 00:28:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714955339; cv=none; b=EfySdzoZicYGmSydjkMZh07MADRI4Lvc6QZD0M9M4hbRvfirIpBT7NB+C688dk2wsn1d6L4id0T2XorwOpjujpDQIkw3E05Pxdw/BjsSXs4+H7qOlmKuF/JwmIt4YoGAktqg8+2a/slgLYGoHpNlggLfLlJyF7rgvpk8nnnsvTs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714955339; c=relaxed/simple;
	bh=YlT9mD5OpOKC3YpFV6MTyxXU29gH5daOUebbs+HVfLg=;
	h=Date:To:From:Subject:Message-Id; b=XvqY1g3ELyoyAADMDOfFF9QDDoNpiL3OXAuaWbr59ouQandWe1NXySgZwEhtLGGyLytfaT8YcTXDzB1lVQO38N3YYLU37VDG0JMefAtR57TOliaOGYjBbTB9SgQ8lg/uai/NF9RZTJtedW1uD2+BU3neqbyZtK5/cbLdg9jqjic=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=TmmopV59; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="TmmopV59"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 260ABC113CC;
	Mon,  6 May 2024 00:28:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1714955339;
	bh=YlT9mD5OpOKC3YpFV6MTyxXU29gH5daOUebbs+HVfLg=;
	h=Date:To:From:Subject:From;
	b=TmmopV59mRxhohFAq2X7DxK8nKwk9qzqw0QQv1NEFCCn7y/8WDJCRxbJt5G4e8BfK
	 6VXQ59dr/vCLbt+/HqeF2s46F+4/XnHrjKTvS66ufQvtEBVG2BuYmn88nFDyzO1Q+r
	 uyhRq/8Dy0ZzrLO+EWrdVoeqfUBX3C+ynHGTq+8M=
Date: Sun, 05 May 2024 17:28:58 -0700
To: mm-commits@vger.kernel.org,conor@kernel.org,john.g.garry@oracle.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-hotfixes-stable] mailmap-add-entry-for-john-garry.patch removed from -mm tree
Message-Id: <20240506002859.260ABC113CC@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mailmap: add entry for John Garry
has been removed from the -mm tree.  Its filename was
     mailmap-add-entry-for-john-garry.patch

This patch was dropped because it was merged into the mm-hotfixes-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: John Garry <john.g.garry@oracle.com>
Subject: mailmap: add entry for John Garry
Date: Fri, 3 May 2024 08:57:36 +0000

get_maintainers.pl sometimes suggests my name and old e-mail address, so
update .mailmap to point to my current e-mail address.

Link: https://lkml.kernel.org/r/20240503085736.3354268-1-john.g.garry@oracle.com
Signed-off-by: John Garry <john.g.garry@oracle.com>
Reported-by: Conor Dooley <conor@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 .mailmap |    1 +
 1 file changed, 1 insertion(+)

--- a/.mailmap~mailmap-add-entry-for-john-garry
+++ a/.mailmap
@@ -292,6 +292,7 @@ Johan Hovold <johan@kernel.org> <jhovold
 Johan Hovold <johan@kernel.org> <johan@hovoldconsulting.com>
 John Crispin <john@phrozen.org> <blogic@openwrt.org>
 John Fastabend <john.fastabend@gmail.com> <john.r.fastabend@intel.com>
+John Garry <john.g.garry@oracle.com> <john.garry@huawei.com>
 John Keeping <john@keeping.me.uk> <john@metanate.com>
 John Moon <john@jmoon.dev> <quic_johmoo@quicinc.com>
 John Paul Adrian Glaubitz <glaubitz@physik.fu-berlin.de>
_

Patches currently in -mm which might be from john.g.garry@oracle.com are


