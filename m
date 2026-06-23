Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 21F3D376BCD;
	Tue, 23 Jun 2026 22:59:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782255585; cv=none; b=WPi9kLn8m2sw38da+5Xq8V9nPgOwsePZh7q2Ei0taWUOrN/2vSYAXtYJXQQs3/50k+ajar017kt/dD30a0EcZfXWt3NKDDDEt+FYtGRlik9Re7lPLaPDNCyjObxFRxbS0GskNkXumJqQYn7DAlsdLOz0n6bvSLQ2YjCVJDjC9dk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782255585; c=relaxed/simple;
	bh=kZl7hvSsVttN+UJwi4O240uJ3Q0wTBTAj8NHWJHdvPs=;
	h=Subject:From:In-Reply-To:References:Message-Id:Date:To:Cc; b=gumf8FDt/8erAN0bdGxnGp5RC/8RLXGGfM4BZhJyo0CFTceM/SYZVVj7zdWGy8XGJpT5RNsqARpDL5AeIc+5U4Zo4Jv6yHV+e5tmwpWXiOLyzmEqh5MCT79HOdXAyemlHHnM1PzxhTY14ePIMN9QC2JRenPH0hIo+RBJCKf83Is=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=BszsdU7/; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="BszsdU7/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BA5F31F000E9;
	Tue, 23 Jun 2026 22:59:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1782255583;
	bh=7IXcfq3gM4m+s/VkQ06cWcybglp/CfQS9+usXoqPFzM=;
	h=Subject:From:In-Reply-To:References:Date:To:Cc;
	b=BszsdU7/nCzdDTP9g2kxjx9nm3+NNarhyLL9fRajMPKyjKUbSOlowhxnVQou+MHbh
	 YbgTJ0s3XBg7iuAxb2nncvJFHl8joZBpHXP/vfDXFs6532tOAnmtNjpIVrB1VtqkLl
	 OrIcv41NBxofcc0T5EB5ofnBkBQwLoAGhDqkPHZnFMUCRXjIWl4ewwGu+5YIkx3JAr
	 8Y3MzlbYxn/+5rD6ylYVpmOx3jMiuAkJdVRiMSf4wu7dslfZqXr7X7mHdpNdSk6aLW
	 b5qm6SlnVWnVExVjqL51ivPhrif1IrOxC2daCqB51rUB9TDpvZn2yZzrmZ4bSfG+D6
	 2/OgwfftsAwpA==
Received: from [10.30.226.235] (localhost [IPv6:::1])
	by aws-us-west-2-korg-oddjob-rhel9-1.codeaurora.org (Postfix) with ESMTP id 56A9A393101D;
	Tue, 23 Jun 2026 22:59:34 +0000 (UTC)
Subject: Re: [GIT PULL] additional MM updates for 7.2-rc1
From: pr-tracker-bot@kernel.org
In-Reply-To: <20260623085840.0819c7694831ca2055e6a733@linux-foundation.org>
References: <20260623085840.0819c7694831ca2055e6a733@linux-foundation.org>
X-PR-Tracked-List-Id: <linux-mm.kvack.org>
X-PR-Tracked-Message-Id: <20260623085840.0819c7694831ca2055e6a733@linux-foundation.org>
X-PR-Tracked-Remote: https://lore.kernel.org/ahRU4OQiGMaLf2Y-@sirena.org.uk Thanks.
X-PR-Tracked-Commit-Id: 13a1e1a618858407fa12c391f664ea750651f6b2
X-PR-Merge-Tree: torvalds/linux.git
X-PR-Merge-Refname: refs/heads/master
X-PR-Merge-Commit-Id: a1a8bab74176eed204a3139ab7ad840caa3d73b8
Message-Id: <178225557296.2458641.3513051191848090904.pr-tracker-bot@kernel.org>
Date: Tue, 23 Jun 2026 22:59:32 +0000
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>, linux-mm@kvack.org, mm-commits@vger.kernel.org, linux-kernel@vger.kernel.org
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>

The pull request you sent on Tue, 23 Jun 2026 08:58:40 -0700:

> https://lore.kernel.org/ahRU4OQiGMaLf2Y-@sirena.org.uk Thanks.

has been merged into torvalds/linux.git:
https://git.kernel.org/torvalds/c/a1a8bab74176eed204a3139ab7ad840caa3d73b8

Thank you!

-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/prtracker.html
