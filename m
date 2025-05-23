Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7376721147B
	for <mm-commits@vger.kernel.org>; Fri, 23 May 2025 22:15:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748038501; cv=none; b=cBzCDnIxt+G4HGMK0Uy6Jorv3erlVExU0xsUT8KFP8LryUy97QgQ2wYkm4I7HCoD3yuiZinaD6Nq4o7QQLaXAQi4cNlfBEKwKZ1zNh7BQ4KJtYnICAisXq+7uuWm5yL2wLOy5yt6Tt8DUxFaY73FZSQJimqWpVP5JolQxsoWOgw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748038501; c=relaxed/simple;
	bh=Y20MWsowgQm/FsYhS8SKT1PaHanz/ffyt8E7v3juzpU=;
	h=Date:To:From:Subject:Message-Id; b=MKaK2d8GrV6g8bHuEdfZdEESrl3JPi5zBKnWN2jzDgcz1gOxsgZb+9Fp/GTIk89GRb46rcVWFLvmsVeSExY6aQVW1oeUHW8W6gZT82IvOfm4PFREKF9H0kxiL3RjjBowo6wDwQ6rGItfZFDepmQBTJCrXojTeQ+87dYoaN+OXMQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=bU6wQArl; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="bU6wQArl"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D6339C4CEE9;
	Fri, 23 May 2025 22:15:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1748038501;
	bh=Y20MWsowgQm/FsYhS8SKT1PaHanz/ffyt8E7v3juzpU=;
	h=Date:To:From:Subject:From;
	b=bU6wQArl07z8oWjPX2WrBcfusuJdMCCZjwWcPkeHMWfW6uM6KDEIkGTYpUh8SArEd
	 jC32wmwF99GqpNR8PXqP92RxzfYmXNmbbEb163s1gZiwfby+DtFXWWLj7fHh6Zbwx0
	 bubag6lElUY8fJ9ZJKinlFoD/gpE3xGOJb2JkyBA=
Date: Fri, 23 May 2025 15:15:00 -0700
To: mm-commits@vger.kernel.org,sw@simonwunderlich.de,kees@kernel.org,carlos.bilbao@kernel.org,antonio@openvpn.net,alexander.sverdlin@gmail.com,jarkko@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mailmap-add-employer-email-address.patch added to mm-hotfixes-unstable branch
Message-Id: <20250523221500.D6339C4CEE9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mailmap: add Jarkko's employer email address
has been added to the -mm mm-hotfixes-unstable branch.  Its filename is
     mailmap-add-employer-email-address.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mailmap-add-employer-email-address.patch

This patch will later appear in the mm-hotfixes-unstable branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next via the mm-everything
branch at git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
and is updated there every 2-3 working days

------------------------------------------------------
From: Jarkko Sakkinen <jarkko@kernel.org>
Subject: mailmap: add Jarkko's employer email address
Date: Fri, 23 May 2025 15:11:04 +0300

Add the current employer email address to mailmap.

Link: https://lkml.kernel.org/r/20250523121105.15850-1-jarkko@kernel.org
Signed-off-by: Jarkko Sakkinen <jarkko@kernel.org>
Cc: Alexander Sverdlin <alexander.sverdlin@gmail.com>
Cc: Antonio Quartulli <antonio@openvpn.net>
Cc: Carlos Bilbao <carlos.bilbao@kernel.org>
Cc: Kees Cook <kees@kernel.org>
Cc: Simon Wunderlich <sw@simonwunderlich.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 .mailmap |    1 +
 1 file changed, 1 insertion(+)

--- a/.mailmap~mailmap-add-employer-email-address
+++ a/.mailmap
@@ -312,6 +312,7 @@ Jan Glauber <jan.glauber@gmail.com> <jgl
 Jan Kuliga <jtkuliga.kdev@gmail.com> <jankul@alatek.krakow.pl>
 Jarkko Sakkinen <jarkko@kernel.org> <jarkko.sakkinen@linux.intel.com>
 Jarkko Sakkinen <jarkko@kernel.org> <jarkko@profian.com>
+Jarkko Sakkinen <jarkko@kernel.org> <jarkko.sakkinen@opinsys.com>
 Jason Gunthorpe <jgg@ziepe.ca> <jgg@mellanox.com>
 Jason Gunthorpe <jgg@ziepe.ca> <jgg@nvidia.com>
 Jason Gunthorpe <jgg@ziepe.ca> <jgunthorpe@obsidianresearch.com>
_

Patches currently in -mm which might be from jarkko@kernel.org are

mailmap-add-employer-email-address.patch

