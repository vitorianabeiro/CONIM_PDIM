package ContractImovel.model.dao;

import java.io.Serializable;
import java.util.List;
import javax.persistence.EntityManager;
import javax.persistence.EntityManagerFactory;
import javax.persistence.Persistence;

import ContractImovel.enums.StatusImovel;
import ContractImovel.model.Imovel;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

public class ImovelDao implements Serializable {
    private static final long serialVersionUID = 1L;

    private static final Logger LOGGER = LoggerFactory.getLogger(ImovelDao.class);

    // Cria o EntityManagerFactory a partir do persistence.xml
    private static final EntityManagerFactory factory =
            Persistence.createEntityManagerFactory("testePU");

    // Sempre gera um novo EntityManager
    private EntityManager getEntityManager() {
        return factory.createEntityManager();
    }

    // ------------------------------
    // SALVAR
    // ------------------------------
    public Imovel salvar(Imovel imovel) {
        LOGGER.info("Salvar DAO... Imóvel = " + imovel);

        EntityManager em = getEntityManager();

        try {
            em.getTransaction().begin();

            Imovel salvo;
            if (imovel.getId() == null) {
                em.persist(imovel);
                salvo = imovel;
            } else {
                salvo = em.merge(imovel);
            }

            em.getTransaction().commit();
            return salvo;

        } catch (Exception e) {
            LOGGER.error("Erro ao salvar imóvel", e);
            if (em.getTransaction().isActive()) em.getTransaction().rollback();
            throw e;

        } finally {
            em.close();
        }
    }

    // ------------------------------
    // EXCLUIR
    // ------------------------------
    public void excluir(Imovel imovel) {
        EntityManager em = getEntityManager();

        try {
            em.getTransaction().begin();

            Imovel i = em.find(Imovel.class, imovel.getId());
            if (i != null) {
                em.remove(i);
            }

            em.getTransaction().commit();

        } catch (Exception e) {
            LOGGER.error("Erro ao excluir imóvel ID: " + imovel.getId(), e);
            if (em.getTransaction().isActive()) em.getTransaction().rollback();
            throw e;

        } finally {
            em.close();
        }
    }

    // ------------------------------
    // BUSCAR POR ID
    // ------------------------------
    public Imovel buscarPeloCodigo(Long id) {
        EntityManager em = getEntityManager();
        try {
            return em.find(Imovel.class, id);
        } finally {
            em.close();
        }
    }

    // ------------------------------
    // BUSCAR TODOS
    // ------------------------------
    @SuppressWarnings("unchecked")
    public List<Imovel> buscarTodos() {
        EntityManager em = getEntityManager();
        try {
            String query = "SELECT i FROM Imovel i";
            return em.createQuery(query).getResultList();

        } finally {
            em.close();
        }
    }

    // ------------------------------
    // BUSCAR DISPONÍVEIS
    // ------------------------------
    @SuppressWarnings("unchecked")
    public List<Imovel> buscarDisponiveis() {
        EntityManager em = getEntityManager();
        try {

            String query = "SELECT i FROM Imovel i WHERE i.statusImovel = :status";

            return em.createQuery(query)
                     .setParameter("status", StatusImovel.DISPONIVEL)
                     .getResultList();

        } finally {
            em.close();
        }
    }
}
