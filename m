From: Andrew Morton <akpm@linux-foundation.org>
Subject: incoming
Date: Mon, 19 Sep 2016 14:43:32 -0700
Message-ID: <20160919144332.be2a1d3a6b4a7ffc65d54c07@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Mon__19_Sep_2016_14_43_32_-0700_XRJ1XfjUlG1Bg6I_"
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:52776 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932199AbcISVno (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 19 Sep 2016 17:43:44 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: mm-commits@vger.kernel.org

--Signature=_Mon__19_Sep_2016_14_43_32_-0700_XRJ1XfjUlG1Bg6I_
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable


20 fixes, based on 3be7988674ab33565700a37b210f502563d932e6:

Subject: mem-hotplug: don't clear the only node in new_node_page()
Subject: ocfs2/dlm: fix race between convert and migration
Subject: MAINTAINERS: Maik has moved
Subject: khugepaged: fix use-after-free in collapse_huge_page()
Subject: mm, thp: fix leaking mapped pte in __collapse_huge_page_swapin()
Subject: mm: avoid endless recursion in dump_page()
Subject: MAINTAINERS: update email for VLYNQ bus entry
Subject: autofs: use dentry flags to block walks during expire
Subject: mm: fix the page_swap_info() BUG_ON check
Subject: ipc/shm: fix crash if CONFIG_SHMEM is not set
Subject: ocfs2: fix trans extend while flush truncate log
Subject: ocfs2: fix trans extend while free cached blocks
Subject: fsnotify: add a way to stop queueing events on group shutdown
Subject: fanotify: fix list corruption in fanotify_get_response()
Subject: ocfs2: fix double unlock in case retry after free truncate log
Subject: mm: memcontrol: make per-cpu charge cache IRQ-safe for socket acco=
unting
Subject: cgroup: duplicate cgroup reference when cloning sockets
Subject: ocfs2: fix start offset to ocfs2_zero_range_for_truncate()
Subject: Revert "ocfs2: bump up o2cb network protocol version"
Subject: rapidio/rio_cm: avoid GFP_KERNEL in atomic context

--Signature=_Mon__19_Sep_2016_14_43_32_-0700_XRJ1XfjUlG1Bg6I_
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBAgAGBQJX4FwPAAoJEJxZ78cCqAIHAdkP/2XmehIXRofImXyhElwcES7g
rWd/veZNrYnl7Oaqf3Px5jE9Geag+A6cVBWLeKLMoNuovEglSgRYS4O5qxJcWHab
PamWcjR2bx0WcURzJnmSdEU+3uZfdU6OOfQ4Mpwn9B9p/gkErd5wvQ+7UgEo0jhB
6uu75MaQ5Ik3Akphh0sy4ikYlK0fB8Q5TuIjD2U+i/rbVl6VVYpITMHWrkyPmXBo
0Loh5A7Par9XRLKM0SnHI3CuRkpYaxxeBuLQF+pxizP4u1DovFggOdSA0PCyH6fF
Mu2WMLz2eQ8UD6XTOBR46ZSUVUZsiohgU0dachy/9lF3BG2v+pKLIP8djHWz5JX3
0CA/JOCPchWGWNLC5JABeV0bzjWJ9r0thgJOsLtRvUWpRAOrJPS6t5gPZ1cPsO1K
I5Bu7PU5FmZuBFRHc9RdKxPsGpEqfp7O+cGE+YRLz7BBoRTeB29TgrK9mX+i/x4w
5hmBKrS4tY9Gk8LsuzzIiITxtz2C8QUIct26lYhDY7ZcLiNwChxpViD/5k+YGcWa
jpgK+OtumS0d5hmQrWeUg++F+vki0LAzslBu14RDpIn80fZDu1oc1Z+CEwn5AXCg
9Ol1VqWHPKhtbp3LuzGoGhXbDEemXZJFceCq2iRcgITjd6+VpIieA+5wpSt+beXm
ailGnWoVDbzN29Ln4ohi
=fhiO
-----END PGP SIGNATURE-----

--Signature=_Mon__19_Sep_2016_14_43_32_-0700_XRJ1XfjUlG1Bg6I_--
