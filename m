Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 22B902F3C1C
	for <mm-commits@vger.kernel.org>; Wed, 25 Jun 2025 22:56:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750892165; cv=none; b=r1Tsyr0/c2q5l+BDwGJ+1ae/ViFQ6PoIhOymRvNnLTRIn+FxW5mDlXpNAdLz0VerzUGqderf02gGN8v13F+EPSBxx5YbUlR/rynTUa+8k0d52/R2VHocGkZu2gqnz4q9NkJpqR2pHJTZhBfq4HzFHCXHQCsuL4iB3xKjM4vhsTQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750892165; c=relaxed/simple;
	bh=7QSaxnIb+sAW4gqmqfICSwvVUOLytNFD35uwT8Ox7YM=;
	h=Date:To:From:Subject:Message-Id; b=EuqxVduWHzW2jbMM+FDrCY7qJCujdL/l7h1oUUF0hnoiS7vhFWgmn0bO88pdlc61L440WrkR71FBfcAFQzrgqEA7XUxwWA4jc80DNKVL71c8JSLKygh7FoNq1IOcqJTlifYv5GOt2I4/7VptsElB4+8bmWW9GcJDZGwJyg8Thd0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=l9onwLQg; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="l9onwLQg"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EC0E5C4CEEA;
	Wed, 25 Jun 2025 22:56:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1750892165;
	bh=7QSaxnIb+sAW4gqmqfICSwvVUOLytNFD35uwT8Ox7YM=;
	h=Date:To:From:Subject:From;
	b=l9onwLQg2G4J/UAtqnbdmlgeLd+e38ZHUqRcZbbMD2GUY+wO1BCL3J38T0tKrFH9W
	 xB0D4g2LBxbaDJz3H/hih5T7BngQmtMrf/AGZiZNsHYBc0+joatqQ+UEuc/7lVlsw4
	 n9M2UtdLyVmZmELkrxTjn7UeCkWJt4GsrUQGEC5I=
Date: Wed, 25 Jun 2025 15:56:04 -0700
To: mm-commits@vger.kernel.org,balejk@matfyz.cz,duje@dujemihanovic.xyz,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-hotfixes-stable] mailmap-update-duje-mihanovics-email-address.patch removed from -mm tree
Message-Id: <20250625225604.EC0E5C4CEEA@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mailmap: update Duje Mihanović's email address
has been removed from the -mm tree.  Its filename was
     mailmap-update-duje-mihanovics-email-address.patch

This patch was dropped because it was merged into the mm-hotfixes-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Duje Mihanović <duje@dujemihanovic.xyz>
Subject: mailmap: update Duje Mihanović's email address
Date: Fri, 20 Jun 2025 11:25:35 +0200

I'm switching to a new mail address, so map my old one to it.

Link: https://lkml.kernel.org/r/20250620-mailmap-v1-1-a6b4b72dbd07@dujemihanovic.xyz
Signed-off-by: Duje Mihanović <duje@dujemihanovic.xyz>
Cc: Karel Balej <balejk@matfyz.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 .mailmap |    1 +
 1 file changed, 1 insertion(+)

--- a/.mailmap~mailmap-update-duje-mihanovics-email-address
+++ a/.mailmap
@@ -223,6 +223,7 @@ Dmitry Safonov <0x7f454c46@gmail.com> <d
 Dmitry Safonov <0x7f454c46@gmail.com> <dsafonov@virtuozzo.com>
 Domen Puncer <domen@coderock.org>
 Douglas Gilbert <dougg@torque.net>
+<duje@dujemihanovic.xyz> <duje.mihanovic@skole.hr>
 Ed L. Cashin <ecashin@coraid.com>
 Elliot Berman <quic_eberman@quicinc.com> <eberman@codeaurora.org>
 Enric Balletbo i Serra <eballetbo@kernel.org> <enric.balletbo@collabora.com>
_

Patches currently in -mm which might be from duje@dujemihanovic.xyz are


