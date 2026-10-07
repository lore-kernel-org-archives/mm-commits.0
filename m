Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AEB53259C80
	for <mm-commits@vger.kernel.org>; Wed,  7 Oct 2026 02:04:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791338693; cv=none; b=KqKtvXFxmbLM/0kjKOJ9SXkwt4GKqGhHogX1junKsjVQdrl/yZh7kWMpSxJ78KLI2EMPyea5GeajQyvL2vvglZFuDO8lBeGXpfAL8ypZ1wuZWbroqvDzDnjpi0nLy2RRdfkkfydJdwG8W5ff2VNAdn4fEv/ehPolFd2GdT7lfyU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791338693; c=relaxed/simple;
	bh=xIYkvIahexaDcayop6hq1GdWcVnmsE3BF26y6yfgLiw=;
	h=Date:To:From:Subject:Message-Id; b=dh+IEiNZ8Hh0mn7CaoEl/y8dLk0KiZwlbNWNI5ovRfbZ9NCxg8kFyW1Z1O1EDp7TyE5Kt7DeIf50eM3YsY1nEJcoEZMhcotobUYADSQvvwvFu3foc85GvaHF0kGqvPaRyevz731uBgHA6xEQ0fbhn0UiawlJ+sL7lhN73Zk33OU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=j0NP0h7N; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="j0NP0h7N"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 83A181F0089B;
	Wed,  7 Oct 2026 02:04:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1791338691;
	bh=P1QC7vtG729kXd+6U5+k4O2yAOa+oehB9LNdG7qdR+o=;
	h=Date:To:From:Subject;
	b=j0NP0h7N13gSmHAKbcXVybbE0RjXqNdoaJKAwEPqFRLHyPvEa6Crn5ZMjL21IO1Ya
	 eMfG+YohmSv9HWU0RMR39xLKIIl1cNf3177DZQxGtxaLcVxSrkkVYOUZ+QqOs3L8h1
	 1+XKEBTQAfuq7H3zN+8S1JHbk2Ds7V2i5SEwkYeY=
Date: Tue, 06 Oct 2026 19:04:51 -0700
To: mm-commits@vger.kernel.org,aliamemis@disroot.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-nonmm-stable] mailmap-update-email-address-for-ali-ahmet-memiş.patch removed from -mm tree
Message-Id: <20261007020451.83A181F0089B@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mailmap: update email address for Ali Ahmet Memiş
has been removed from the -mm tree.  Its filename was
     mailmap-update-email-address-for-ali-ahmet-memiş.patch

This patch was dropped because it was merged into the mm-nonmm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Ali Ahmet Memiş <aliamemis@disroot.org>
Subject: mailmap: update email address for Ali Ahmet Memiş
Date: Sat, 5 Sep 2026 22:49:39 +0300

I'm switching to my disroot address for kernel contributions.  Map the
address my earlier patches were sent from to it, so that get_maintainer.pl
stops offering the old one as a recipient.

Also switch to the proper spelling of my name with diacritics, which is
what I use with the new address.

Link: https://lore.kernel.org/20260905195000.556185-1-aliamemis@disroot.org
Signed-off-by: Ali Ahmet Memiş <aliamemis@disroot.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 .mailmap |    1 +
 1 file changed, 1 insertion(+)

--- a/.mailmap~mailmap-update-email-address-for-ali-ahmet-memiş
+++ a/.mailmap
@@ -67,6 +67,7 @@ Alex Hung <alexhung@gmail.com> <alex.hun
 Alex Shi <alexs@kernel.org> <alex.shi@intel.com>
 Alex Shi <alexs@kernel.org> <alex.shi@linaro.org>
 Alex Shi <alexs@kernel.org> <alex.shi@linux.alibaba.com>
+Ali Ahmet Memiş <aliamemis@disroot.org> <ali@iusegentoo.com>
 Alice Mikityanska <alice.kernel@fastmail.im> <maxtram95@gmail.com>
 Alice Mikityanska <alice.kernel@fastmail.im> <maximmi@mellanox.com>
 Alice Mikityanska <alice.kernel@fastmail.im> <maximmi@nvidia.com>
_

Patches currently in -mm which might be from aliamemis@disroot.org are


