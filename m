Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 69F48C433EF
	for <mm-commits@archiver.kernel.org>; Fri, 22 Oct 2021 06:42:40 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 485C5610D2
	for <mm-commits@archiver.kernel.org>; Fri, 22 Oct 2021 06:42:40 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231897AbhJVGo4 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 22 Oct 2021 02:44:56 -0400
Received: from gandalf.ozlabs.org ([150.107.74.76]:45747 "EHLO
        gandalf.ozlabs.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229609AbhJVGo4 (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 22 Oct 2021 02:44:56 -0400
Received: from authenticated.ozlabs.org (localhost [127.0.0.1])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-256) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (No client certificate requested)
        by mail.ozlabs.org (Postfix) with ESMTPSA id 4HbFCK3NDgz4xbL;
        Fri, 22 Oct 2021 17:42:37 +1100 (AEDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=canb.auug.org.au;
        s=201702; t=1634884957;
        bh=nZsMVF+GaNeHEHyQSrkv9YKI3JnONPv/ud+w9zcXluE=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=sOlstiFwlYCqQSX3ezAOJ3iJDyB1POJC3YHhx5kcifZr4JV7uOtyORBtVhjHhynVT
         7i3f3WkQ04jiF2q42CnpqBIEAIgJPCBnHUqDF1jR4hKRt22ZWKA+HapsBCnrlwu/6D
         4KWD7MHlSEg5yyc80Unjh4keiEpCF27vs6op64rtkQ9MbIBgyM4j1TVHm3h5iYrEjo
         BREqPJzTqIbS7M0i8VUczxkp4sid49GLTusXDpezBc5OtTUO21KKgBnwEo2a83SMoL
         bpELwTpfNFpBLpdDExl9Al7U7ddxRGJJeVlaTovosqI+gvfvMdIYJ+WBNiNaBG4hSz
         +HO1nN3gIfh5Q==
Date:   Fri, 22 Oct 2021 17:42:36 +1100
From:   Stephen Rothwell <sfr@canb.auug.org.au>
To:     akpm@linux-foundation.org
Cc:     bot@kernelci.org, mm-commits@vger.kernel.org, nathan@kernel.org,
        shy828301@gmail.com
Subject: Re: +
 mm-shmem-dont-truncate-page-if-memory-failure-happens-fix.patch added to
 -mm tree
Message-ID: <20211022174236.04c3b2ed@canb.auug.org.au>
In-Reply-To: <20211022023529.rGwWR0IKz%akpm@linux-foundation.org>
References: <20211022023529.rGwWR0IKz%akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="Sig_/hchnE/slImpw0a2r9rQWfQn";
 protocol="application/pgp-signature"; micalg=pgp-sha256
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

--Sig_/hchnE/slImpw0a2r9rQWfQn
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

Hi all,

On Thu, 21 Oct 2021 19:35:29 -0700 akpm@linux-foundation.org wrote:
>
> The patch titled
>      Subject: mm/memory_failure: initialize extra_pins in me_pagecache_cl=
ean()
> has been added to the -mm tree.  Its filename is
>      mm-shmem-dont-truncate-page-if-memory-failure-happens-fix.patch

Added to linux-next today.

--=20
Cheers,
Stephen Rothwell

--Sig_/hchnE/slImpw0a2r9rQWfQn
Content-Type: application/pgp-signature
Content-Description: OpenPGP digital signature

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEENIC96giZ81tWdLgKAVBC80lX0GwFAmFyXVwACgkQAVBC80lX
0Gwt5gf/fXt0q0e6pTcnIdW8XnDF39MUDdoD+NYAv3eIM/ZoXRFiICQ16S83jMoK
pAgzVAwBqpSw08kyK6YPpK/ixGGfppF8WsdM9MttbZjffc0QmkF3EChvlKRGo07U
Pydbgs+xYEDe3biOPwLrJaDK3DZ6EYGMjDTXwll4xgdIBKXY98rRXKQjmtMJPDQX
4G1XYXx2DcyqArtuQXFFWhxndRgMZECwjLp5vhNKLHNOAMUyf94xtpSw1DMwLl5E
P/H43c3KbtIjMYfjKydnlXlp7zrCuhyWq5F0YAAIcc8j/gJAcA/+xQtiSAvSdzmy
BI4RGFcZoDw732Uvnzy7K71WSxk83w==
=GhMi
-----END PGP SIGNATURE-----

--Sig_/hchnE/slImpw0a2r9rQWfQn--
